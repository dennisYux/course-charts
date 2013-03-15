class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end  

  def in_progress
    @projects = Project.where("due_at>=?", Time.now.weeks_ago(1))
  end

  def history
    @projects = Project.where("due_at<?", Time.now.weeks_ago(1))
  end

  def report

  end
end