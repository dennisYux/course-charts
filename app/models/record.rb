class Record < ActiveRecord::Base
  # attr_accessible :title, :body

  # attributes
  attr_accessible :user_name, :description, :hours 

  # model hooks
  belongs_to :task

end
