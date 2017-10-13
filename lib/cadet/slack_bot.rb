module Cadet
  class SlackBot
    attr_accessor :client

    def initialize
      @client = Slack::RealTime::Client.new
    end

    def execute
      setup_handshake
      setup_message_handlers
      setup_close_handler
      setup_closed_handler

      start!
    end

    def setup_message_handlers
      client.on :message do |data|
        case data.text
        when 'bot hi' then
          client.message channel: data.channel, text: "Hi <@#{data.user}>!"
        when 'bot how many companies?'
          client.message channel: data.channel, text: "The current number of companies are #{Company.count}"
        when /^bot/ then
          client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
        end
      end
    end

    def setup_handshake
      client.on :hello do
        puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
      end
    end

    def setup_close_handler
      client.on :close do |_data|
        puts "Client is about to disconnect"
      end
    end

    def setup_closed_handler
      client.on :closed do |_data|
        puts "Client has disconnected successfully!"
      end
    end

    def start!
      client.start!
    end
  end
end
