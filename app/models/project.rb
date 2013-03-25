class Project < ActiveRecord::Base
  require 'utilities'

  # attributes
  attr_accessible :name, :description, :manager, :due_at

  # validations
  validates_presence_of :name

  # model hooks
  # project should not be destroied
  has_and_belongs_to_many :users, join_table: :users_projects
  has_many :tasks, dependent: :destroy
  has_many :records, through: :tasks
  has_many :invitations, dependent: :destroy

  # callbacks
  before_save :fill_due_at

  private
  
  def fill_due_at
    self.due_at = due_at.end_of_day
  end
end
