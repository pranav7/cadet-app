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
        when /^bot how many boards/i then
          client.message channel: data.channel, text: "#{Board.count} boards"
        when /^bot how many posts/i then
          client.message channel: data.channel, text: "#{Post.count} posts"
        when /^bot how many votes/i then
          client.message channel: data.channel, text: "#{Vote.count} votes"
        when /^bot how many comments/i then
          client.message channel: data.channel, text: "#{Comment.count} comments"
        when /^bot how many users/ then
          client.message channel: data.channel, text: "#{Users.count} users"
        when /^bot print daily report/i then
          client.message channel: data.channel, text: daily_stats_report
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

    def daily_stats_report
      message = "*Companies*: #{Company.count}"
      message << "\n*Boards*: #{Board.count}"
      message << "\n*Posts*: #{Post.count}"
      message << "\n*Votes*: #{Vote.count}"
      message << "\n*Comments*: #{Comment.count}"

      message << "\n\n"
      Company.all.each do |company|
        message << "*#{company.name} (http://#{company.subdomain}.getcadet.com/)*"
        message << "\n```\n"
        message << "Boards: #{company.boards.count}"
        posts = company.boards.collect(&:posts).flatten
        message << ", Posts: #{posts.count}"
        message << ", Votes: #{posts.collect(&:votes).flatten.count}"
        message << ", Comments: #{posts.collect(&:comments).flatten.count}"
        message << "\n```\n"
      end

      message
    end
  end
end
