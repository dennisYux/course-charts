class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

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
end
