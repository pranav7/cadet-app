class NotifySlackJob < ApplicationJob
  queue_as :default

  def perform(message)
    client = Slack::Web::Client.new
    client.chat_postMessage(channel: APP_CONFIG['slack']['channel'], text: message, as_user: true)
  end
end
