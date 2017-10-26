class CommentNotificationMailer < ApplicationMailer
  def new_comment(user, comment)
    @user = user
    @comment = comment
    @commenter = comment.created_by
    @post = comment.post

    mail(
      subject: "New Comment on #{@post.title}",
      to: @user.email,
      from: 'hello@getcadet.com'
    )
  end
end
