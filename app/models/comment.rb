class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :content, as: :parent

  accepts_nested_attributes_for :content

  after_create :touch_post_last_activity
  after_create :send_notifications

  scope :without_notes, -> { where.not(private: true) }

  def note?
    !!self.private
  end

  def send_notifications
    notify_admins

    if staff_commented? && requester_not_admin?
      notify_requester
    end
  end

  def commenter
    user
  end

  def notify_admins
    post.company.admins.each do |admin|
      next if admin == commenter

      CommentNotificationMailer.new_comment(self, admin).deliver_later
    end
  end

  def notify_requester
    CommentNotificationMailer.new_comment(self, post.created_by).deliver_later
  end

  private

  def touch_post_last_activity
    post.touch(:last_activity_at)
  end

  def staff_commented?
    commenter.admin_of?(post.company)
  end

  def requester_not_admin?
    !post.requester.admin_of?(post.company)
  end
end
