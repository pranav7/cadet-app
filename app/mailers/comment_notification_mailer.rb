class CommentNotificationMailer < ApplicationMailer
  def new_comment(comment, user)
    @user = user
    @post = comment.post
    @company = @post.company
    @comment = comment
    @commenter = comment.commenter
    @host = @company.host

    if @user.admin_of?(@company)
      @board_url = admin_board_post_url(@post.board, @post, host: @host)
      @comment_url =
        admin_board_post_url(@post.board, @post, host: @host) +
        "#comment-#{@comment.id}"
    else
      @board_url = board_post_url(@post.board, @post, host: @host)
      @comment_url =
        board_post_url(@post.board, @post, host: @host) +
        "#comment-#{@comment.id}"
    end

    mail(
      subject: "New Comment on #{@post.title}",
      to: "#{@user.name} <#{@user.email}>",
      form: from_address
    )
  end
end
