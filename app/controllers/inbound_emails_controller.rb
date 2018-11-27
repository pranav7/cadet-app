class InboundEmailsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def consume
    @email = Hashie::Mash.new(JSON.parse(request.body.read))
    post = Post.find(post_id)

    options = {}
    options[:private] = true if notification_type == "note"
    Comment.create_from_email(@email, post, options)

    head :no_content
  end

  private
  def post_id
    @email.MailboxHash.split("-").last.to_i
  end

  def notification_type
    @email.MailboxHash.split("-").first
  end
end
