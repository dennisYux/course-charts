module UsersHelper  
  def in_progress_projects_names_of(user)
    names = []
    user.in_progress_projects.each do |project|
      names << project.name
    end
    names
  end

  def tasks_names_of(project)
    names = []
    project.tasks.each do |task|
      names << task.name
    end
    names
  end
end