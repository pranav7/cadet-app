class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :content, as: :parent

  accepts_nested_attributes_for :content

  after_create :touch_post_last_activity
  after_create :send_notifications

  def send_notifications
    notify_admins
    notify_requester if staff_commented?
  end

  def commenter
    user
  end

  def notify_admins
    post.company.admins.each do |admin|
      next if admin == commenter

      CommentNotificationMailer.new_comment(admin, self).deliver_later
    end
  end

  def notify_requester
    CommentNotificationMailer.new_comment(post.created_by, self).deliver_later
  end

  private

  def touch_post_last_activity
    post.touch(:last_activity_at)
  end

  def staff_commented?
    commenter.admin_of?(post.company)
  end
end
