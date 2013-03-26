class TeamsController < ApplicationController
  before_filter :authenticate_user!

  def create
    user = current_user
    project = Project.find(params[:project_id])
    emails = separate_emails_from params[:emails]
    dup_emails = []
    uni_emails = []
    emails.each do |email|
      # no need to send an invitation if user has been in the project
      if project.users.exists?(email: email)
        dup_emails << email
      else
        invitation = project.invitations.find_or_create_by_email(email: email)
        TeamManager.invitation(user, project, email, invitation.invitation_token).deliver        
        uni_emails << email
      end
    end
    # display error messages if there are duplicated emails
    if dup_emails.any?
      flash[:alert] = "Invitations were not sent due to users have joined this project : "
      dup_emails.each do |dup|
        flash[:alert] << "[ "+dup+" ] "
      end
    end    
    flash[:notice] = "Invitations valid were successfully sent !" if uni_emails.any?
    redirect_to project
  end

  #
  # handle user's confirmation on invitations
  #
  def show
    invitation_token = params[:invitation_token]
    invitation = Invitation.find_by_invitation_token(invitation_token)
    if invitation.nil?
      redirect_to root_path, alert: "Invalid invitation token !"
    else
      user = User.find_by_email(invitation.email)
      project = Project.find(invitation.project_id)
      user.projects << project
      # delete invitation once setup
      Invitation.destroy(invitation)
      redirect_to project, notice: "You have successfully joined a project !"
    end
  end

  #
  # preprocess received emails parameters
  #
  def separate_emails_from(str)
    emails = []
    strs = str.split ','
    strs.each do |str|
      # email validations   
      email = str.strip.downcase   
      emails << email if !emails.include?(email) and email =~ /^([\da-z_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/ 
    end
    emails
  end
end
