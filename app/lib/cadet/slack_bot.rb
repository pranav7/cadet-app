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
        client.typing channel: data.channel

        message = Slack::Messages::Formatting.unescape(data.text)
        case message
        when 'bot hi' then
          client.message channel: data.channel, text: "Hi <@#{data.user}>!"
        when /^bot how many companies/i then
          client.message channel: data.channel, text: "The current number of companies are #{Company.count}"
        when /^bot get trial expiry for (.+)$/i then
          client.message channel: data.channel, text: get_trial_expiry($1)
        when /^bot extend expiry for (.+) by (.+) days$/ then
          duration = $2.to_i.days
          client.message channel: data.channel, text: extend_expiry($1, duration)
        when /^bot update (.+) to paying$/ then
          client.message channel: data.channel, text: update_to_paying
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

    private
      def update_to_paying(subdomain)
        company = Company.find_by_subdomain subdomain

        if company
          company.company_setting.expires_at = nil
          company.company_setting.save

          "#{company.name} is now a paying customer!"
        else
          "Sorry! I did not find a company with subdomain: #{subdomain}"
        end
      end

      def extend_expiry(subdomain, duration)
        company = Company.find_by_subdomain subdomain

        if company
          company.company_setting.expires_at = Time.now  + duration
          company.company_setting.save

          "#{company.name}'s trial expires on #{company.company_setting.expires_at}"
        else
          "Sorry! I did not find a company with subdomain: #{subdomain}"
        end
      end

      def get_trial_expiry(subdomain)
        company = Company.find_by_subdomain subdomain

        if company
          return "#{company.name} is a paying company" if company.paying?

          "#{company.name}'s trial expires on #{company.company_setting.expires_at}'"
        else
          "Sorry! I did not find a company with subdomain: #{$1}"
        end
      end
  end
end
