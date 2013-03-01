require 'spec_helper'

describe Task do

  before(:each) do
    @attr = {
      name: "Task 1",
      due_at: Time.next_month.to_datetime
      created_at: Time.now.to_datetime
    }
  end
  
  pending "add some examples to (or delete) #{__FILE__}"
end
