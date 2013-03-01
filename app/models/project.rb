class Project < ActiveRecord::Base

	# attributes
	attr_accessible :name, :description, :manager, :bmonth, :byear, :emonth, :eyear

  # model hooks
  has_and_belongs_to_many :users, joint_table: :users_projects
  has_many :tasks
  has_many :records, through: :tasks

end
