class Task < ActiveRecord::Base
  # attr_accessible :title, :body

  # attributes
  attr_accessible :name, :due_at

  # model hooks
  has_many :records, dependent: :destroy
  belongs_to :task

end