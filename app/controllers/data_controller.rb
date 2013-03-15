class DataController < ApplicationController
  def overview

  end

  def project
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

  	# project parameters
  	tasks = project.tasks

  	# tasks hours
  	tasks_hours = []
  	tasks.each do |task|
  		tasks_hours << task.hours_used
  	end
  	charts_data[:tasks_hours] = tasks_hours

  	charts_data
  end


end
