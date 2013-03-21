class ProjectsController < ApplicationController

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/1
  def show    
    @project = Project.find(params[:id])
  end

  # GET /projects/new
  def new
    @project = Project.new
    @tasks = [Task.new] * 4
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @tasks = @project.tasks
    @tasks << Task.new while @tasks.count < 4
  end

  # POST /projects
  def create
    separate_params
    @project = Project.new(@project_params)
    if project_saved?
      redirect_to @project, notice: "Project was successfully created."
    else
      prepare_params_for_view 
      render action: 'new'
    end
  end

  # PUT /projects/1
  def update
    separate_params
    @project = Project.find(params[:id])
    if project_updated?
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
  def separate_params
    @project_params = params[:project]
    @tasks_params = @project_params.delete(:task)
    @tasks_params.each do |i, task_params|      
      task_params[:tag] = i
    end
  end

  #
  # true if the project and all tasks are saved
  # false otherwise
  #
  def project_saved?
    begin  
      @project.transaction do  
        save_project!
        save_tasks!
      end
      return true  
    rescue Exception => e
      return false
    end 
  end

  def save_project!     
    @project.save!
    @project.contracts.create!(user_id: current_user.id)
  end

  #
  # new tasks might need to be created 
  # in both save and update cases
  #
  def update_tasks!    
    @tasks_params.each do |i, task_params|
      # primary key, only one task expected
      task = Task.where("project_id=? and tag=?", @project.id, i).first
      if task.nil?        
        @project.tasks.create!(task_params)
      else
        task.update_attributes!(task_params)
      end
    end
  end

  alias :save_tasks! :update_tasks!

  #
  # true if the project and all tasks are updated
  # false otherwise
  #
  def project_updated?
    begin  
      @project.transaction do  
        update_project!
        update_tasks!
      end
      return true  
    rescue Exception => e
      return false
    end 
  end

  def update_project!
    @project.update_attributes!(@project_params)
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
end
