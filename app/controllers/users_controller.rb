class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end  

  def in_progress
    @user = current_user
    @projects = @user.in_progress_projects
    @project = @projects.first
    @task = @project.tasks.first
    @record = @user.records.build
  end

  def history
    @user = current_user
    @projects = @user.history_projects
  end

  def report
  end
end