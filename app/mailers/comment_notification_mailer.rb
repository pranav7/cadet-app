class CommentNotificationMailer < ApplicationMailer
  def new_comment(comment, user)
    @user = user
    @comment = comment
    @commenter = @comment.commenter
    @post = @comment.post
    @company = @post.company
    @host = @company.host

    build_comment_and_board_urls(@user)

    if @comment.note?
      @type = "note"
      @subject = "New Note: #{@post.title}"
    else
      @type = "comment"
      @subject = "New Reply: #{@post.title}"
    end

    headers["X-CADET-COMPANY"] = @company.subdomain
    headers["X-CADET-NOTIFICATION-TYPE"] = @type

    mail(
      subject: @subject,
      to: @user.formatted_address,
      from: from_address
    )
  end

  def mention(comment, mentionee)
    @mentionee = mentionee
    @user = mentionee

    @comment = comment
    @post = comment.post
    @company = @post.company
    @commenter = comment.commenter
    @type = @comment.note? ? "note" : "comment"
    @host = @company.host

    headers["X-CADET-COMPANY"] = @company.subdomain
    headers["X-CADET-NOTIFICATION-TYPE"] = @type

    build_comment_and_board_urls(@mentionee)

    mail(
      subject: "#{@commenter.name} mentioned you in a #{@type}",
      to: @mentionee.formatted_address,
      from: from_address
    )
  end

  private

  def build_comment_and_board_urls(user)
    if user.admin_of?(@company)
      @post_url = admin_board_post_url(@post.board, @post, host: @host)
      @comment_url =
        admin_board_post_url(@post.board, @post, host: @host) +
        "#comment-#{@comment.id}"
    else
      @post_url = board_post_url(@post.board, @post, host: @host)
      @comment_url =
        board_post_url(@post.board, @post, host: @host) +
        "#comment-#{@comment.id}"
    end
  end
end
