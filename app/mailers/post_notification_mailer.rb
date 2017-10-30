class PostNotificationMailer < ApplicationMailer
  def new_post(post, user)
    @post = post
    @company = @post.company
    @user = user
    @requester = post.created_by
    @host = @company.host

    build_post_url

    mail(
      subject: "New Post #{@post.title} in #{@post.board.name}",
      to: @user.formatted_address,
      from: from_address
    )
  end

  def upvote(vote, user)
    @post = vote.post
    @upvoter = vote.user
    @company = @post.company
    @user = user
    @host = @company.host

    build_post_url

    mail({
      subject: "#{@upvoter.name} upvoted #{@post.title}",
      to: @user.formatted_address,
      from: from_address
    })
  end

  def status_changed(post, user)
    @post = post
    @company = @post.company
    @user = user
    @host = @company.host

    build_post_url

    mail({
      subject: "#{@post.title} was marked as ##{@post.status}",
      to: @user.formatted_address,
      from: from_address
    })
  end

  private

  def build_post_url
    if @user.admin_of?(@post.company)
      @post_url = admin_board_post_url(@post.board, @post, host: @host)
    else
      @post_url = board_post_url(@post.board, @post, host: @host)
    end
  end
end
