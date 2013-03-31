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

    # time period
    from = project.created_at.to_date
    to = project.due_at.to_date + 1.week
    charts_data[:project_hours_from] = from 
    charts_data[:project_hours_to] = to

    # prepare data  
    charts_data[:project_hours] = groups_total_hours(project.records, from, to, 30) 

    ### chart tasks span ###

    # time period
    from = project.created_at.to_date
    to = project.due_at.to_date + 1.week
    charts_data[:tasks_span_from] = from 
    charts_data[:tasks_span_to] = to

    # prepare data 
    tasks_span = []
    tasks = project.tasks
    tasks.each do |task|
      records = task.records
      #
      # task expected time span from task creation to due
      # task practical time span from first record creation to last record creation
      #
      tasks_span << {task: 'Task '+(task.tag+1).to_s, create: task.created_at.to_date, due: task.due_at.to_date,
        start: records.minimum("created_at").to_date, finish: records.maximum("created_at").to_date}
    end

    # add extra data for the whole project
    records = project.records
    tasks_span.unshift({task: 'Project', create: project.created_at.to_date, due: project.due_at.to_date,
      start: records.minimum("created_at").to_date, finish: records.maximum("created_at").to_date})

    charts_data[:tasks_span] = tasks_span

    ### chart tasks hours ###

    # prepare data 
    tasks_hours = []
    #
    # at least one task has to be specified on the project creation
    #
    tasks = project.tasks
    tasks.each do |task|
      tasks_hours << {task: 'Task '+(task.tag+1).to_s, total_hours: task.records.sum("hours")}
    end
    charts_data[:tasks_hours] = tasks_hours

    ### chart tasks submission ###

    # time period
    from = project.created_at.to_date
    to = project.due_at.to_date + 1.week
    charts_data[:tasks_submission_from] = from 
    charts_data[:tasks_submission_to] = to

    # prepare data 
    tasks_submission = []
    #
    # at least one task has to be specified on the project creation
    #
    tasks = project.tasks
    tasks.each do |task|
      # records (submitted by all team members) are grouped with task
      records = task.records.where("records.created_at >= ?", from)
      records.each do |record|
        tasks_submission << {task: task.name, date: record.created_at.to_date, 
          time: record.created_at.strftime("%H-%M-%S"), hours: record.hours}
      end
    end
    charts_data[:tasks_submission] = tasks_submission

    charts_data.to_json
  end
end
