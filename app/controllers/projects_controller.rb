class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /projects
  def index
    @user = current_user
    @in_progress_projects = @user.in_progress_projects
    @history_projects = @user.history_projects
  end

  # GET /projects/1
  def show    
    @project = Project.find(params[:id])
    @leader = @project.users.find_by_name(@project.manager)
    @members = @project.users.where("name!=?", @project.manager)
    @tasks = [Task.new] + @project.tasks
    @record = Record.new
    # decide whether or not to display navigation tags
    @navigation_tags = !nil

    respond_to do |format|
      format.html { render action: 'show' }
      format.json { render json: charts_data_for(@project) } 
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    @tasks = [Task.new]
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @tasks = @project.tasks
  end

  # POST /projects
  def create
    initiate_params
    if project_saved?
      redirect_to @project, notice: "Project was successfully created."
    else
      prepare_params_for_view 
      render action: 'new'
    end
  end

  # PUT /projects/1
  def update
    initiate_params
    if project_saved?
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      prepare_params_for_view
      render action: 'edit'
    end
  end

  # DELETE /projects/1
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully deleted.'
  end

  private
  
  #
  # categorize params
  #
  def initiate_params
    @project_params = params[:project]
    @tasks_params = @project_params.delete(:task)
    @tasks_params.each do |i, task_params|      
      task_params[:tag] = i
    end
    # instance parameters
    @user = current_user
    @project = @user.projects.where(id: params[:id]).first
    @project = Project.new(@project_params) if @project.nil?
  end

  #
  # true if the project and all tasks are saved
  # false otherwise
  #
  def project_saved?
    begin  
      @project.transaction do
        # validations
        ensure_unique_project_name!
        ensure_unique_tasks_names!  
        # save
        save_project!
        save_tasks!
      end
      return true  
    rescue Exception => e
      return false
    end 
  end

  #
  # create or update project as needed
  #
  def save_project!
    #
    # use "@user.project.create" creates contract besides project
    # given "@user.project.build"+"@project.save" does not create contract
    # since we have a separate model contract ...
    #     
    @project.id.nil? ? @project = @user.projects.create!(@project_params) : @project.update_attributes!(@project_params)
  end

  #
  # create or update tasks as needed
  # project should have a valid id
  #
  def save_tasks!    
    @tasks_params.each do |i, task_params|
      # primary key, only one task expected
      task = Task.where("project_id=? and tag=?", @project.id, i).first
      task.nil? ? @project.tasks.create!(task_params) : task.update_attributes!(task_params)
    end
  end

  #
  # project names are forced unique for single user
  # however, they are allowed duplicated among different users 
  #
  def ensure_unique_project_name!
    dup_name_projects = @user.projects.where("name=?", @project.name)
    dup_name_projects.each do |project|
      raise RuntimeError, 'Duplicated project name' if project.id != @project.id
    end
  end

  #
  # tasks names are forced unique for single project
  # however, they are allowed duplicated among different projects 
  #
  def ensure_unique_tasks_names! 
    for i in 0..(@tasks_params.count-2)
      for j in (i+1)..(@tasks_params.count-1)
        raise RuntimeError, 'Duplicated tasks names' if @tasks_params[i.to_s][:name] == @tasks_params[j.to_s][:name]
      end
    end
  end

  #
  # fill form with user inputs
  #
  def prepare_params_for_view
    # parameters used when render views 
    @project = Project.new(@project_params)
    @tasks = []
    @tasks_params.each do |i, task_params|
      @tasks << Task.new(task_params)
    end
  end

  #
  # prepare charts data for a specific project
  #
  def charts_data_for(project)
    charts_data = {}

    ### chart project hours ###
    project_hours = []
    #
    # always show the whole timeline 
    # it should display the chart frame even if currently there is no data 
    #
    project_hours << {date: project.created_at.to_date.prev_week, total_hours: 0}
    project_hours << {date: project.due_at.to_date.next_week, total_hours: 0}
    records = project.records.select("date(records.created_at) as create_date, sum(hours) as total_hours")
                             .group("date(records.created_at)")
    records.each do |record|
      project_hours << {date: record.create_date, total_hours: record.total_hours}
    end
    charts_data[:project_hours] = project_hours

    ### chart tasks span ###
    tasks_span = []
    tasks = project.tasks
    tasks.each do |task|
      records = task.records
      #
      # task expected time span from task creation to due
      # task practical time span from first record creation to last record creation
      # time is translated into days since project creation
      #
      tasks_span << {task: 'Task '+(task.tag+1).to_s,
        create: days_difference(task.created_at, project.created_at),
        due: days_difference(task.due_at, project.created_at),
        start: days_difference(records.minimum("created_at"), project.created_at),
        finish: days_difference(records.maximum("created_at"), project.created_at)}
    end
    charts_data[:tasks_span] = tasks_span

    ### chart tasks hours ###
    tasks_hours = []
    #
    # at least a task has to be specified at the project creation
    #
    tasks = project.tasks
    tasks.each do |task|
      tasks_hours << {task: 'Task '+(task.tag+1).to_s, total_hours: task.records.sum("hours")}
    end
    charts_data[:tasks_hours] = tasks_hours

    charts_data.to_json
  end

  def days_difference(time1, time2)
    # in case there is no record in task
    return 0 if time1.nil?
    (time1.to_date-time2.to_date).to_i
  end
end
