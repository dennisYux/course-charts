class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.all
  end

  def show
    @user = current_user
    @projects = @user.projects
    @in_progress_projects = @user.in_progress_projects
    @leader_projects = @user.projects.where("manager = ?", @user.name)
    @records = @user.records

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

    # time period
    from = user.registered_at.to_date
    to = Time.now.to_date + 1.week
    charts_data[:user_hours_from] = from 
    charts_data[:user_hours_to] = to

    # prepare data  
    charts_data[:user_hours] = groups_total_hours(current_user.records, from, to, 30)  

    ### chart user submission ###

    # time period
    from = Time.now.to_date.prev_month
    to = Time.now.to_date 
    charts_data[:user_submission_from] = from 
    charts_data[:user_submission_to] = to

    # prepare data 
    user_submission = []
    user.projects.each do |project|
      # records are grouped with project
      records = project.records.where("records.created_at >= ? and user_id = ?", from, user.id)
      records.each do |record|
        user_submission << {project: project.name, date: record.created_at.to_date, 
          time: record.created_at.strftime("%H-%M-%S"), hours: record.hours}
      end
    end
    charts_data[:user_submission] = user_submission
    
    charts_data.to_json
  end
end