class TeamsController < ApplicationController
  def create
    user = current_user
    id = params[:project_id]
    project = Project.find(id)
    emails = separate_emails_from params[:emails]
    emails.each do |email|
      invitation_token = invitation_token(email, id)
      invitation = project.invitations.find_or_create_by_invitation_token(invitation_token: invitation_token, 
        email: email, project_id: id)
      # update invitation sent time
      invitation.invitation_sent_at = Time.now
      invitation.save
      TeamManager.invitation(user, project, email, invitation_token).deliver
    end
    redirect_to project, notice: "Invitations were sucessfully sent !"
  end

  def show
    invitation_token = params[:invitation_token]
    invitation = Invitation.find_by_invitation_token(invitation_token)
    user = User.find_by_email(invitation.email)
    if user.nil?
      #
      # mark user(email) and project association
      # once user is signed up with the same email, he/she automatically joins the project  
      #
      invitation.invitation_accepted = "yes"
      invitation.save
    else
      # add user and project association
      project = Project.find(invitation.project_id)
      user.projects << project
      redirect_to project
    end
  end

  #
  # preprocess received emails parameters
  #
  def separate_emails_from(str)
    emails = []
    strs = str.split ','
    strs.each do |str|
      emails << str.strip
    end
    emails
  end

  #
  # generate invitation token
  #
  def invitation_token(email, id)
  end
end
