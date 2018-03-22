source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.0.rc1'
gem "pg", "< 1.0"
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'react-rails'
gem 'autoprefixer-rails'
gem 'bourbon'
gem 'simple_form'
gem 'slim-rails'
gem 'devise'
gem 'devise_invitable', '~> 1.7.0'
gem 'omniauth-google-oauth2'
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git'
gem 'friendly_id', '>= 5.1.0'
gem 'slack-ruby-client'
gem 'eventmachine'
gem 'faye-websocket'
gem 'postmark-rails'
gem 'sidekiq'
gem 'exception_notification'
gem 'slack-notifier' # Need for exception_notification gem
gem 'health_check'
gem 'octicons_helper'
gem 'webpacker', '~> 3.0'
gem "intercom-rails"

# All HTML Pipeline for Content Formatting Gems
gem 'html-pipeline'
gem 'html-pipeline-rouge_filter'
gem 'commonmarker'
gem 'gemoji'
gem 'rinku'
gem 'sanitize'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'pry-rails'

  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem "chromedriver-helper"

  gem 'rspec'
  gem 'rspec-rails', '~> 3.6'
  gem 'rspec-mocks'
  gem 'rails-controller-testing'

  gem 'factory_girl_rails'
  gem 'faker', '~> 1.7.3'
  gem 'shoulda-matchers'
  gem 'timecop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', '~> 0.54.0', require: false

  gem 'capistrano', '< 3.10.0'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-rvm'
  gem 'capistrano-npm'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
