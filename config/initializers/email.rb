# some custom configs for mailers
defined?(Rails.application.config.x.email) || Rails.application.config.x.email = {}
Rails.application.config.x.email.sandbox_to_address = ENV["GANCH_SANDBOX_TO_EMAIL_ADDRESS"]
Rails.application.config.x.email.intercept_mail = true
Rails.application.config.x.email.bcc_address = ENV["GANCH_BCC_EMAIL_ADDRESS"]