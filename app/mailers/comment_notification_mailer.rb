class CommentNotificationMailer < ApplicationMailer
  def new_comment(comment, user)
    @user = user
    @comment = comment
    @commenter = comment.commenter
    @post = comment.post
    @company = @post.company
    @host = @company.host

    if @user.admin_of?(@company)
      @board_url = admin_board_post_url(@post.board, @post, host: @host)
      @comment_url =
        admin_board_post_url(@post.board, @post, host: @host)
        "#comment-#{@comment.id}"
    else
      @board_url = board_post_url(@post.board, @post, host: @host)
      @comment_url =
        board_post_url(@post.board, @post, host: @host)
        "#comment-#{@comment.id}"
    end

    mail(
      subject: "New Comment on #{@post.title}",
      to: @user.email,
    )
  end
end
