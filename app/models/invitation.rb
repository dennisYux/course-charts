class Invitation < ActiveRecord::Base
  # attributes
  attr_accessible :invitation_token, :email, :project_id, :invitation_sent_at, :invitation_accepted

  # validations

  # model hooks
  belongs_to :project
end
