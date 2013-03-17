class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end  

  def in_progress
    @user = current_user
    @projects = []
    @user.projects.each do |project|
      @projects << project if project.due_at >= Time.now.weeks_ago(1)
    end
  end

  def history
    @user = current_user
    @projects = []
    @user.projects.each do |project|
      @projects << project if project.due_at < Time.now.weeks_ago(1)
    end
  end

  def report

  end
end