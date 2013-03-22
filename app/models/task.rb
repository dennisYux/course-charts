class Task < ActiveRecord::Base
  require 'utilities'

  # attributes
  attr_accessible :name, :tag, :due_at

  # validations
  validates_presence_of :name

  # model hooks  
  # task should not be destroied
  has_many :records, dependent: :destroy
  has_many :users, through: :records
  belongs_to :project

  # callbacks
  before_save :fill_due_at

  private

  def fill_due_at
    self.due_at = due_at.end_of_day
  end
end
