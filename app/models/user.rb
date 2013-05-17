class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :provider, :uid

  # validations
  validates_presence_of :name

  # model hooks
  # user should not be destroied  
  has_and_belongs_to_many :projects, join_table: :users_projects
  has_many :records, dependent: :destroy
  has_many :tasks, through: :records

  # bypasses Devise's requirement to re-enter current password to edit
  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end  

  def in_progress_projects
    projects.where("due_at >= ?", Time.now.weeks_ago(1))
  end

  def history_projects
    projects.where("due_at < ?", Time.now.weeks_ago(1))
  end

  def is_leader?(project)
    name == project.manager
  end

  #
  # return created_at or confirmed_at as needed
  #
  def registered_at
    created_at
  end

  #
  # omniauthentication with facebook
  #
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                           )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
