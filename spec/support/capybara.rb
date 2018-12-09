JS_DRIVER = :selenium_chrome_headless

RSpec.configure do |config|
  Capybara.default_driver = :rack_test
  Capybara.javascript_driver = JS_DRIVER
  Capybara.default_max_wait_time = 2

  Capybara.register_driver :selenium do |app|
    if ENV['SELENIUM_DRIVER_URL'].present?
      Capybara::Selenium::Driver.new(
        app,
        browser: :remote,
        url: ENV.fetch('SELENIUM_DRIVER_URL'),
        desired_capabilities: :chrome
      )
    end
  end
end
