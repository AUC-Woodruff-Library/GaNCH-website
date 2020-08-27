require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ganch
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # config.active_job.queue_adapter = :delayed_job

    config.action_controller.default_protect_from_forgery = true
    config.wikidata_url = 'https://query.wikidata.org'
    config.action_mailer.default_options = {
      from: "ganch.project@gmail.com",
      host: "ganch.galileo.usg.edu"
    }

    # use a env variable to open signup route
    config.permit_signups = false

    # who to contact for support
    config.support_email = ENV['GANCH_EMAIL']
  end
end
