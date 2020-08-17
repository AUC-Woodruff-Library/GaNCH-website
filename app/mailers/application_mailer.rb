class ApplicationMailer < ActionMailer::Base
  # TODO: set default 'from' address
  default from: 'from@example.com'
  layout 'mailer'
end
