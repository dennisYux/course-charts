class Record < ActiveRecord::Base
  # attr_accessible :title, :body

  # attributes
  attr_accessible :description, :hours 

  # model hooks
  belongs_to :task
  belongs_to :user

  def started_at
  	return created_at - hours.hours
  end

  def done_at
  	return created_at
  end

end
