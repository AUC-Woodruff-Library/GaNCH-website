class UserMailer < ApplicationMailer
  default reply_to: 'noreply@galileo.usg.edu'
  @@url  = Rails.configuration.action_mailer.default_options[:host] || 'http://localhost:3000/login'

  def welcome_email
    @user = params[:user]
    @url = @@url
    logger.info "Welcome email generated for user: #{@user.attributes.inspect}"
    mail(to: @user.email, subject: 'Welcome to GaNCH')
  end
end
