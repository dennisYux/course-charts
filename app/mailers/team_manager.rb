class TeamManager < ActionMailer::Base
  default from: "mailer@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.team_manager.invitation.subject
  #
  def invitation(user, project, email, invitation_token)
    @user = user
    @project = project
    @invitation_token = invitation_token

    mail to: email, subject: "Team invitation"
  end
end
