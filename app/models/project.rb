class Project < ActiveRecord::Base
  require 'utilities'

  # attributes
  attr_accessible :name, :description, :manager, :due_at

  # validations

  # model hooks
  # project should not be destroied
  has_many :contracts, dependent: :destroy
  has_many :users, through: :contracts
  has_many :tasks, dependent: :destroy
  has_many :records, through: :tasks

  # callbacks
  before_save :fill_due_at

  private
  
  def fill_due_at
    self.due_at = due_at.end_of_day
  end
end
