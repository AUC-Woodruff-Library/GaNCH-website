class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = 'http://localhost:300/login'
    logger.info "Welcome email generated for user: #{@user.attributes.inspect}"
    mail(to: @user.email, subject: 'Welcome to GaNCH')
  end
end
