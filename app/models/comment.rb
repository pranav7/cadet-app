class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :content, as: :parent

  accepts_nested_attributes_for :content

  after_create :touch_post_last_activity
  after_create :send_notifications

  def send_notifications
    notify_admins
    notify_requester
  end

  def created_by
    user
  end

  private

  def touch_post_last_activity
    post.touch(:last_activity_at)
  end

  def notify_admins
    post.company.admins.each do |admin|
      next if admin == created_by

      CommentNotificationMailer.new_comment(admin, self).deliver_now
    end
  end

  def notify_requester
  end
end
