Raven.configure do |config|
  unless Rails.env.development?
    config.dsn = Rails.application.secrets.sentry_dsn
  end

  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments = ['staging', 'production']
end
