JS_DRIVER = :selenium_chrome_headless

Capybara.default_driver = :rack_test
Capybara.javascript_driver = JS_DRIVER
Capybara.default_max_wait_time = 2

RSpec.configure do |config|
  Capybara.register_driver :selenium do |app|
    if ENV['SELENIUM_DRIVER_URL'].present?
      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: ENV.fetch('SELENIUM_DRIVER_URL'),
        desired_capabilities: :chrome
      )
    else
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
  end

  config.after(:each) do
    Capybara.use_default_driver
  end
end
