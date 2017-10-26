# Preview all emails at http://localhost:3000/rails/mailers/comment_notification_mailer
class CommentNotificationMailerPreview < ActionMailer::Preview
  def new_comment
   CommentNotificationMailer.new_comment(User.first, Comment.first)
  end
end
