class Record < ActiveRecord::Base
  # attributes
  attr_accessible :description, :hours

  # validations
  validates_presence_of :description, :hours

  # model hooks
  belongs_to :task
  belongs_to :user
end
