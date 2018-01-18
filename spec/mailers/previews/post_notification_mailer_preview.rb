# Preview all emails at http://localhost:3000/rails/mailers/post_notification_mailer
class PostNotificationMailerPreview < ActionMailer::Preview
  def new_post
    PostNotificationMailer.new_post(Post.last, User.last)
  end

  def upvote
    PostNotificationMailer.upvote(Post.first.votes.first, User.first)
  end

  def status_changed
    PostNotificationMailer.status_changed(Post.last, "closed", User.last)
  end
end
