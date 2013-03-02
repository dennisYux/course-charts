require 'spec_helper'

describe Project do

  before(:each) do
    @attr = {
      name: "Example Project",
      description: "This is an example project",
      manager: "Leader"
            
      # due_at: Time.next_month.to_datetime
      # created_at: Time.now.to_datetime
      # done_at: Time.now.to_datetime
    }
  end

  pending "add some examples to (or delete) #{__FILE__}"
end
