class RecordsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    project = Project.find(params[:project_id])
    record = Record.new(hours: params[:record][:hours], description: params[:record][:description])
    record.user_id = current_user.id
    record.task_id = params[:task]
    if record.save
      redirect_to project, notice: "Record was sucessfully submitted !"
    end
  end
end