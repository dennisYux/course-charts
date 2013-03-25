class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    @user = current_user
    @projects = @user.in_progress_projects
    @tasks = @projects.any? ? @projects.first.tasks : Task.new
    @record = Record.new
  end
end