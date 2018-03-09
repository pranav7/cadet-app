class NotifySlackJob < ApplicationJob
  queue_as :default

  def perform(message, options = {})
    return unless Rails.env.production?

    channel = options.delete(:channel) || APP_CONFIG['slack']['channel']

    client = Slack::Web::Client.new
    client.chat_postMessage(channel: channel, text: message, as_user: true)
  end
end
