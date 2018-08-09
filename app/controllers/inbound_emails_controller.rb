class InboundEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def consume
    @email = Hashie::Mash.new(JSON.parse(request.body.read))
    post = Post.find(post_id.to_i)

    options = {}
    options[:private] = true if notification_type == "note"
    Comment.create_from_email(@email, post, options)

    head :no_content
  end

  private
    def post_id
      @email.Headers.each do |header|
        return header.Value if header.Name == "X-Cadet-PostId"
      end
    end
    
    def notification_type
      @email.Headers.each do |header|
        return header.Value if header.Name == "X-Cadet-Notification-Type"
      end
    end
end
