require 'spec_helper'

describe Project do

  before(:each) do
    @attr = {
      name: "Example Project",
      description: "This is an example project",
      manager: "Leader",
      due: "03-31-2013"
            
      # due_at: Time.next_month.to_datetime
      # created_at: Time.now.to_datetime
      # done_at: Time.now.to_datetime
    }
  end

  it "should accept valid due dates" do
    dates = %w[02-29-2012 03-31-2013 12-01-2014]
    dates.each do |date|      
      valid_due_project = Project.new(@attr.merge(due: date))
      valid_due_project.should be_valid
    end
  end

  it "should reject invalid due dates" do
    dates = %w[03-31 03/31/2013 02-29-2013]
    dates.each do |date|      
      invalid_due_project = Project.new(@attr.merge(due: date))
      invalid_due_project.should_not be_valid
    end
  end


end
