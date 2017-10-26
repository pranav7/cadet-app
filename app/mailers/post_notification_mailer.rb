class PostNotificationMailer < ApplicationMailer
  def new_post(post, user)
    @post = post
    @company = @post.company
    @user = user
    @requester = post.created_by
    @host = @company.host

    if @user.admin_of?(@post.company)
      @post_url = admin_board_post_url(post.board, post, host: @host)
    else
      @post_url = board_post_url(@post.board, @post, host: @host)
    end

    mail(
      subject: "New Post #{@post.title} in #{@post.board.name}",
      to: @user.email
    )
  end
end
