# Preview all emails at http://localhost:3000/rails/mailers/post_notification_mailer
class PostNotificationMailerPreview < ActionMailer::Preview
  def new_post
    PostNotificationMailer.new_post(Post.first, User.first)
  end
end
