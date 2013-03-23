class DataController < ApplicationController

  #
  # respond data for in progress projects' charts
  #
  def in_progress_projects
    projects = current_user.in_progress_projects
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

    charts_data
  end

  def days_difference(time1, time2)
    # in case there is no record in task
    return 0 if time1.nil?
    (time1.to_date-time2.to_date).to_i
  end
end
