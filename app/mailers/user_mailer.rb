class UserMailer < ApplicationMailer
  def reset_pass_email(user)
    @user = user
    mail(to: @user.email, subject: 'Reset Password')
  end
end
