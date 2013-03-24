class TeamManager < ActionMailer::Base
  default from: "mailer@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.team_manager.invitation.subject
  #
  def invitation(user, project, email)
    @user = user
    @project = project

    mail to: email, subject: "Team invitation"
  end
end
