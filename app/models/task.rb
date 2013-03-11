class Task < ActiveRecord::Base

  require 'utilities'

  # attributes
  attr_accessible :name, :tag, :due_at

  # validations

  # model hooks  
  # task should not be destroied
  has_many :records, dependent: :destroy
  has_many :users, through: :records
  belongs_to :project

  # callbacks
  before_save :fill_due_at

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

  def fill_due_at
  	self.due_at = due_at.end_of_day
  end

end
