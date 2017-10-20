Raven.configure do |config|
  config.dsn = APP_CONFIG['sentry']
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
