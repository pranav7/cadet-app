JS_DRIVER = :selenium_chrome_headless

RSpec.configure do |config|
  Capybara.default_driver = :rack_test
  Capybara.javascript_driver = JS_DRIVER
  Capybara.default_max_wait_time = 2
end
