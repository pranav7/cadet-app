Rails.application.config.middleware.use OmniAuth::Builder do
  provider :intercom, ENV['459610f5-95ab-419d-bbe7-f22f104a46bd'], ENV['bbe9e1e2-9d5e-47f0-a449-4b1c43ff8561'], verify_email: false
end
