class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.action_mailer.default_options[:from]

  @@url  = Rails.configuration.action_mailer.default_options[:host] || 'http://localhost:3000/login'

  layout 'mailer'
end
