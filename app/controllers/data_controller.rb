class DataController < ApplicationController

  #
  # respond data for in progress projects' charts
  #
  def in_progress_projects
   	projects = current_user.projects.where("due_at > ?", Time.now.weeks_ago(1))
    data = []
    projects.each do |project|
    	data << charts_data_for(project)
    end
    # respond with json data
    respond_to do |format|
      format.json { render json: data.to_json }
    end
  end

  #
  # respond data for current project(specified by id)'s charts
  #
  def project
    project = current_user.projects.find(params[:id])
    data = [charts_data_for(project)]
    # respond with json data
    respond_to do |format|
      format.json { render json: data.to_json }
    end
  end

  private

  #
  # prepare charts data for a specific project
  #
  def charts_data_for(project)
   	charts_data = {}

    ### chart project hours ###
    project_hours = []
    records = project.records.select("date(records.created_at) as create_date, sum(hours) as total_hours")
                             .group("date(records.created_at)")
    records.each do |record|
      project_hours << {date: record.create_date, total_hours: record.total_hours}
    end
    charts_data[:project_hours] = project_hours

    ### chart tasks span ###
    tasks_span = []
    project_create_date = project.created_at.to_date
    tasks = project.tasks
    tasks.each do |task|
      records = task.records
      #
      # task expected time span from task creation to due
      # task practical time span from first record creation to last record creation
      # time is translated into days since project creation
      #
      tasks_span << {task: 'Task '+(task.tag+1).to_s,
        create: (task.created_at.to_date - project_create_date).to_i,
        due: (task.due_at.to_date - project_create_date).to_i,
        start: (records.minimum("created_at").to_date - project_create_date).to_i,
        finish: (records.maximum("created_at").to_date - project_create_date).to_i}
    end
    charts_data[:tasks_span] = tasks_span

    ### chart tasks hours ###
    tasks_hours = []
    tasks = project.tasks
    tasks.each do |task|
      tasks_hours << {task: 'Task '+(task.tag+1).to_s, total_hours: task.records.sum("hours")}
    end
    charts_data[:tasks_hours] = tasks_hours

    charts_data
  end
end
