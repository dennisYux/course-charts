class Task < ActiveRecord::Base

  require 'utilities'

  # attributes
  attr_accessor :due
  attr_accessible :name, :due

  # validations
  validate :dates_format

  # model hooks  
  # task should not be destroied
  has_many :records, dependent: :destroy
  has_many :users, through: :records
  belongs_to :project

  # callbacks
  before_save :fill_dates

  def started_at
  	# initiate with task due (> start time of target records)
  	start = due_at
  	# get start time of the earlist record
  	records.each do |r|
  		start = r.started_at if start > r.started_at
  	end
  	return start
  end

  def done_at
    # initiate with task creation time (< done time of target records)
    done = created_at
    # get done time of the latest record
    records.each do |r|
      done = r.done_at if done < r.done_at
    end
    return done
  end

  private
  
  def dates_format
  	errors.add(:task, "should have dates in the format of 'MM-DD'") unless valid_dates?
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
