class RemindersController < ApplicationController

  # DELETE /reminders/send-reminders
  # using DELETE for confirmation guardrails
  def send_reminders_confirm
    logger.info("Sending reminders to all recipients.")
    @user = current_user

    # remove duplicates from overall list of organizations
    total = Recipient.all.sort_by(&:id)
    uniq = total.uniq { |r| r.wikidata_url }
    @recipients = uniq.filter { |u| !u.email.empty? }
    @errors = uniq.filter { |u| u.email.empty? }

    @notice = 'Batch delivery of reminder emails has begun.'
    @level = :notice

    # send the emails
    if Rails.env.production?
      @recipients.each do |recipient|
        RecipientMailer.with(recipient: @recipient, user: @user).reminder_email.deliver_later
      end
    else
      @notice = 'Batch delivery of reminder emails blocked (non-production environment).'
      @level = :warn
    end


    # report to the user
    flash.now[@level] = @notice
    respond_to do |format|
      format.html { render 'reminders_sent' }
    end
  end

end