class SandboxEmailInterceptor
  # use a configured address to bcc or re-route emails
  @sandbox_to = Rails.configuration.x.email.sandbox_to_address

  def self.delivering_email(message)
    # append an additional recipient for testing
    # message.to << @sandbox_to

    # replace real recipient with sandboxed
    message.to = [@sandbox_to]
    Rails.logger.debug("Intercepting email: #{message.inspect}", )
    # message will send after here
  end
end