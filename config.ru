# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# https://github.com/slack-ruby/slack-ruby-bot/blob/master/TUTORIAL.md#configru
Thread.abort_on_exception = true
thread = Thread.new do
  begin
    Cadet::SlackBot.new.execute
  rescue Exception => e
    Rails.logger.warning "ERROR: #{e}"
    Rails.logger.warning e.backtrace
    raise e
  end
end

run Rails.application
