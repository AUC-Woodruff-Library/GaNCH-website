class RecipientMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

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