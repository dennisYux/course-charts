class DataController < ApplicationController

  def in_progress
  	@projects = Project.where("due_at > ?", Time.now.weeks_ago(1))

  	data = []
  	@projects.each do |project|
  		data << charts_data_for(project)
  	end

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

    #
    # data are retrieved with standard SQL query language 
    #

  	# project parameters
  	tasks = project.tasks
    tasks_ids = []
    tasks.each do |task|
      tasks_ids << task.id
    end

    # project timeline
    project_timeline = []
    records = Record.select("date(created_at) as record_date, sum(hours) as total_hours")
                    .where(task_id: tasks_ids)
                    .group("date(created_at)")
                    .order("date(created_at)")
    records.each do |record|
      project_timeline << {date: record.record_date, total_hours: record.total_hours}
    end
    charts_data[:project_timeline] = project_timeline

  	# tasks hours
  	tasks_hours = []
  	tasks.each do |task|
  		tasks_hours << task.hours_used
  	end
  	charts_data[:tasks_hours] = tasks_hours

  	charts_data
  end


end
