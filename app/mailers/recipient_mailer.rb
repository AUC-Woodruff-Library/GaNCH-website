class RecipientMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  default from: 'noreply@galileo.usg.edu'
  default reply_to: 'ganch.project@gmail.com'

  add_template_helper(RecipientsHelper)
  add_template_helper(ApplicationHelper)

  def reminder_email
    @recipient = params[:recipient]
    @user = params[:user]

    logger.info "Reminder email generated for recipient: #{@recipient.inspect}"
    mail(
      to: @recipient.email,
      bcc: [@user.email],
      subject: 'Review and update your organization’s emergency contact information'
    )
  end
end