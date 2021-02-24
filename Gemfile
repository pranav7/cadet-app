source 'https://rubygems.org'

ruby '2.4.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'api-pagination', '4.8.1'
gem 'autoprefixer-rails', '7.2.5'
gem 'bourbon', '5.0.0'
gem 'carrierwave', '2.1.1'
gem 'coffee-rails', '4.2.2'
gem 'devise', '4.7.1'
gem 'devise_invitable', '1.7.2'
gem 'eventmachine', '1.2.5'
gem 'exception_notification', '4.2.2'
gem 'fast_jsonapi', '1.4'
gem 'faye-websocket', '0.11.0'
gem 'fog-aws', '3.8.0'
gem "font-awesome-rails", '4.7.0.7'
gem 'friendly_id', '5.2.3'
gem 'hashie', '4.1.0'
gem 'health_check', '2.7.0'
gem "intercom-rails", '0.4.0'
gem 'jbuilder', '2.7.0'
gem 'jquery-rails', '4.3.1'
gem 'kaminari', '1.1.1'
gem 'octicons_helper', '4.2.0'
gem 'omniauth-google-oauth2', '0.8.0'
gem 'omniauth-intercom', '0.1.9'
gem "pg", "0.21.0"
gem "php-serialize", '1.2.0'
gem 'postmark-rails', '0.15.0'
gem 'puma', '3.12.4'
gem 'rails', '5.2.4.4'
gem 'react-rails', '2.4.7'
gem 'sass-rails', '5.0.7'
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git'
gem 'sidekiq', '5.0.5'
gem 'simple_form', '5.0.0'
gem 'slack-notifier', '2.3.2' # Need for exception_notification gem
gem 'slack-ruby-client', '0.11.0'
gem 'slim-rails', '3.1.3'
gem 'turbolinks', '5.1.0'
gem 'uglifier', '4.1.3'
gem 'webpacker', '5.2.1'

# All HTML Pipeline for Content Formatting Gems
gem 'commonmarker', '0.17.7.1'
gem 'gemoji', '3.0.0'
gem 'html-pipeline', '2.7.1'
gem 'html-pipeline-rouge_filter', '1.0.6'
gem 'rinku', '2.0.4'
gem 'sanitize', '4.5.0'

# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '9.1.0', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'pry-rails'
  gem 'rb-readline'

  gem 'capybara', '~> 2.7.1'
  gem 'selenium-webdriver'

  gem 'rails-controller-testing'
  gem 'rspec', '3.7.0'
  gem 'rspec-mocks', '~> 3.6'
  gem 'rspec-rails', '~> 3.6'

  gem 'factory_girl_rails'
  gem 'faker', '~> 1.7.3'
  gem 'shoulda-matchers'
  gem 'timecop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '3.5.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop', '~> 0.83.0', require: false
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'

  gem 'capistrano', '< 3.10.0'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-npm', '1.0.2'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano-rvm', '0.1.2'
  gem 'capistrano-sidekiq', '0.20.0'
  gem 'capistrano3-puma'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
