class Contract < ActiveRecord::Base

	# attributes


	# model hooks
	belongs_to :user
	belongs_to :project

end
