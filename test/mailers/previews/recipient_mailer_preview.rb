# Preview all emails at http://localhost:3000/rails/mailers/recipient_mailer
class RecipientMailerPreview < ActionMailer::Preview
  def reminder_email
    RecipientMailer.with(recipient: Recipient.first, user: User.first).reminder_email
  end
end