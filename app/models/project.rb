class Project < ActiveRecord::Base

  require 'utilities'

	# attributes
	attr_accessor :due
	attr_accessible :name, :description, :manager, :due

  # validations
  validate :dates_format

  # model hooks
  # project should not be destroied
  has_many :contracts, dependent: :destroy
  has_many :users, through: :contracts
  has_many :tasks, dependent: :destroy
  has_many :records, through: :tasks

  # callbacks
  before_save :fill_dates

  def started_at
  	# initiate with project due (> start time of target tasks)
  	start = due_at
  	# get start time of the earlist task
  	tasks.each do |t|
  		start = t.started_at if start > t.started_at
  	end
  	return start
  end

  def done_at
    # initiate with project creation time (< done time of target tasks)
    done = created_at
    # get done time of the latest task
    tasks.each do |t|
      done = t.done_at if done < t.done_at
    end
    return done
  end

  private

  def dates_format
  	errors.add(:project, "should have dates in the format of 'MM-DD'") unless valid_dates?
  end

  def valid_dates?
  	valid_due?
  end

  def valid_due?
  	due.valid_datestr?
  end

  def fill_dates
  	fill_due_at
  end

  def fill_due_at
  	self.due_at = due.datestr_to_datetime
  end

end
