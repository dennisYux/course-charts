class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end  

  def show
  	@user = current_user
  	@projects = @user.projects
  end
end