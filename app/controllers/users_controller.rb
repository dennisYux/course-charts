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

    respond_to do |format|
      format.html { render action: 'show' }
      format.json { render json: charts_data_for(@user) } 
    end
  end

  #
  # prepare charts data for a user
  #
  def charts_data_for(user)
    charts_data = {}

    ### chart user hours ### 

    from = user.registered_at.to_date.prev_week
    to = Time.now.to_date.next_week
    #
    # always show the whole timeline 
    # it should display the chart frame even if currently there is no data 
    #   
    charts_data[:user_hours] = groups_total_hours(current_user.records, from, to, 30)  

    charts_data.to_json
  end
end