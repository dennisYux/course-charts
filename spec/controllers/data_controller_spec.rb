require 'spec_helper'

describe DataController do

  describe "GET 'overview'" do
    it "returns http success" do
      get 'overview'
      response.should be_success
    end
  end

  describe "GET 'project'" do
    it "returns http success" do
      get 'project'
      response.should be_success
    end
  end

end
