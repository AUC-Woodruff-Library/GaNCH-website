class UserMailer < ApplicationMailer
  default from: 'noreply@galileo.usg.edu'
  default reply_to: 'ganch.project@gmail.com'

  def welcome_email
    @user = params[:user]
    @url = @@url
    logger.info "Welcome email generated for user: #{@user.attributes.inspect}"
    mail(to: @user.email, subject: 'Welcome to GaNCH')
  end
end
