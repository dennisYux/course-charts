require 'spec_helper'

describe Record do

  before(:each) do
    @attr = {
      user_name: "Example User",
      description: "Task 1 model",
      hours: 2.5,
      created_at: Time.now.to_datetime
    }
  end
  
  pending "add some examples to (or delete) #{__FILE__}"
end
