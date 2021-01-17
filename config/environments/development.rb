Rails.application.configure do
  config.webpacker.check_yarn_integrity = true # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: "app.lvh.me", port: "3000" }

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end

CarrierWave.configure do |config|
  # config.fog_credentials = {
  #   provider: 'AWS', # required
  #   aws_access_key_id: Rails.application.secrets.aws[:access_key], # required unless using use_iam_profile
  #   aws_secret_access_key: Rails.application.secrets.aws[:secret_key], # required unless using use_iam_profile
  #   # use_iam_profile:       true,                         # optional, defaults to false
  #   region: 'us-east-2' # optional, defaults to 'us-east-1'
  #   # host:                  's3.example.com',             # optional, defaults to nil
  #   # endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  # }
  config.fog_directory  = 'cadet-local-images' # required
  config.fog_public     = true # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" } # optional, defaults to {}
  # For an application which utilizes multiple servers but does not need caches persisted across requests,
  # uncomment the line :file instead of the default :storage.  Otherwise, it will use AWS as the temp cache store.
  # config.cache_storage = :file
end
