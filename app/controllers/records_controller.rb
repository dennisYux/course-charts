class RecordsController < ApplicationController
  def create
    @user = current_user
    @project = @user.projects.find_by_name(params[:record][:project][:name])
    @task = @project.tasks.find_by_name(params[:record][:task][:name])
    @record = @user.records.build(hours: params[:record][:hours], description: params[:record][:description])
    @record.task_id = @task.id
    if @record.save!
      redirect_to account_path, notice: "Record was sucessfully submitted !"
    end
  end
end