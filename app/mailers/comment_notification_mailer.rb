class CommentNotificationMailer < ApplicationMailer
  def new_comment(user, comment)
    @user = user
    @comment = comment
    @commenter = comment.created_by
    @post = comment.post
    @company = @post.company

    if @user.admin_of?(@company)
      @board_url = admin_board_post_url(@post.board, @post, host: "#{@post.company.subdomain}.#{APP_CONFIG['base_domain']}")
      @comment_url =
        admin_board_post_url(@post.board, @post, host: "#{@post.company.subdomain}.#{APP_CONFIG['base_domain']}") + 
        "#comment-#{@comment.id}"
    else
      @board_url = board_post_url(@post.board, @post, host: "#{@post.company.subdomain}.#{APP_CONFIG['base_domain']}")
      @comment_url =
        board_post_url(@post.board, @post, host: "#{@post.company.subdomain}.#{APP_CONFIG['base_domain']}") + 
        "#comment-#{@comment.id}"
    end

    mail(
      subject: "New Comment on #{@post.title}",
      to: @user.email,
      from: 'hello@getcadet.com'
    )
  end
end
