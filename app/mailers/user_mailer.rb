class UserMailer < ActionMailer::Base
  
  def send_account_creation_mail(user, current_user)
    @user, current_user = user, current_user
    @from = "#{current_user.name} <#{current_user.email}>"
    @roles = @user.roles.join(' and')
    @subject = "You have been added on Questionnaire as #{@roles}"
    @subject = ('[' + Rails.env + '] ' + @subject) unless Rails.env == "production"
    
    mail(:to => @user.email, :from =>  @from, :cc => current_user.email, :subject => @subject)

  end
end