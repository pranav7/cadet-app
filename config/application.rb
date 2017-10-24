require_relative 'boot'

require 'rails/all'
require "active_storage"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CadetApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    Raven.configure do |config|
      config.dsn = 'https://13928da26c524ca28e360bb8b389df2f:2d53846d5dff4e519464a84205933aa4@sentry.io/233281'
    end    

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
