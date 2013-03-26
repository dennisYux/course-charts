class Invitation < ActiveRecord::Base
  # attributes
  attr_accessible :email, :project_id

  # validations

  # model hooks
  belongs_to :project

  # callbacks
  before_create :generate_token

  #
  # generate unique invitation token
  #
  def generate_token
    begin
      self.invitation_token = SecureRandom.urlsafe_base64
    end while Invitation.exists?(invitation_token: self.invitation_token)  
  end
end
