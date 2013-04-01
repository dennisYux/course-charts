module ProjectsHelper
  #
  # mark with additional icon if current_user is the team leader
  #
  def smart_link_to(project)
    html = ""
    if current_user.is_leader? project
      html = '<p>'+(link_to raw(project.name+' <i class="icon-map-marker blue"></i>'), project)+'</p>'
    else      
      html = '<p>'+(link_to project.name, project)+'</p>'
    end
    html.html_safe
  end
end
