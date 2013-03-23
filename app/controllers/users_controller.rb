class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end  

  def in_progress
    @user = current_user
    @projects = @user.in_progress_projects
    # serve for the record submission
    if @projects.any?
      @project = @projects.first
      # at least one task has to be created
      @task = @project.tasks.first
      @record = @user.records.build
    end
  end

  def history
    @user = current_user
    @projects = @user.history_projects
  end

  def report
  end
end