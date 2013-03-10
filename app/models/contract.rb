class Contract < ActiveRecord::Base

	# attributes
	attr_accessible :user_id, :project_id

	# model hooks
	belongs_to :user
	belongs_to :project

end
