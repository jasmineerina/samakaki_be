class UserMailer < ApplicationMailer
  def reset_pass_email(user)
    @user = user
    mail(to: @user.email, subject: 'Reset Password')
  end

 def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registration Confirmation")
 end
end
