class Record < ActiveRecord::Base
  # attributes
  attr_accessible :description, :hours

  # model hooks
  belongs_to :task
  belongs_to :user
end
