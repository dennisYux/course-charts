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

  def started_at
  	# initiate with project due (> start time of target tasks)
  	start = due_at
  	# get start time of the earlist task
  	tasks.each do |t|
  		start = t.started_at if start > t.started_at
  	end
  	start
  end

  def done_at
    # initiate with project creation time (< done time of target tasks)
    done = created_at
    # get done time of the latest task
    tasks.each do |t|
      done = t.done_at if done < t.done_at
    end
    done
  end

  # consider to remove
  def hours_used
    hours = 0
    tasks.each do |t|
      hours += t.hours_used
    end   
    hours 
  end

  private

  def fill_due_at
  	self.due_at = due_at.end_of_day
  end


end
