class RemindersController < ApplicationController

  # DELETE /reminders/send-reminders
  # using DELETE for confirmation guardrails
  def send_reminders_confirm
    logger.info("Sending reminders to all recipients.")
    total = Recipient.all.sort_by(&:id)
    uniq = total.uniq { |r| r.wikidata_url }
    @recipients = uniq.filter { |u| !u.email.empty? }
    @errors = uniq.filter { |u| u.email.empty? }
    respond_to do |format|
      format.html { render 'reminders_sent', notice: 'Batch delivery of reminder emails has begun.' }
    end
  end
end
