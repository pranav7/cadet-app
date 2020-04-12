source 'https://rubygems.org'

ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'autoprefixer-rails'
gem 'bourbon'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.5.0'
gem 'devise_invitable', '~> 1.7.0'
gem 'eventmachine'
gem 'exception_notification'
gem 'faye-websocket'
gem 'friendly_id', '>= 5.1.0'
gem 'hashie'
gem 'health_check'
gem "intercom-rails"
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'octicons_helper'
gem 'omniauth-google-oauth2'
gem 'omniauth-intercom', '~> 0.1.9'
gem "pg", "< 1.0"
gem "php-serialize"
gem 'postmark-rails'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.3'
gem 'react-rails'
gem 'sass-rails', '~> 5.0'
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git'
gem 'sidekiq'
gem 'simple_form', '~> 5.0.0'
gem 'slack-notifier' # Need for exception_notification gem
gem 'slack-ruby-client'
gem 'slim-rails'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 3.0'

# All HTML Pipeline for Content Formatting Gems
gem 'commonmarker'
gem 'gemoji'
gem 'html-pipeline'
gem 'html-pipeline-rouge_filter'
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
  gem 'rb-readline'

  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'

  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'rspec-rails', '~> 3.6'

  gem 'factory_girl_rails'
  gem 'faker', '~> 1.7.3'
  gem 'shoulda-matchers'
  gem 'timecop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop', '~> 0.54.0', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano', '< 3.10.0'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-npm'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
  gem 'capistrano3-puma'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
