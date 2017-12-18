class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :content, as: :parent

  accepts_nested_attributes_for :content

  after_create :touch_post_last_activity
  after_commit :send_notifications, on: :create

  scope :without_notes, -> { where.not(private: true) }

  def note?
    !!self.private
  end

  def send_notifications
    notify_admins
    notify_requester if should_notify_requester?
    notify_slack
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
    CommentNotificationMailer.new_comment(self, post.requester).deliver_later
  end

  private

  def touch_post_last_activity
    post.touch(:last_activity_at)
  end

  def should_notify_requester?
    not(note?) && staff_commented? && requester_not_admin?
  end

  def staff_commented?
    commenter.admin_of?(post.company)
  end

  def requester_not_admin?
    !post.requester.admin_of?(post.company)
  end

  def notify_slack
    return if Rails.env.test?

    message = "*New Comment - ##{post.company.subdomain}*"
    message << "\n#{commenter.formatted_address} commented on _#{post.title}_ in #{post.board.name}"

    NotifySlackJob.perform_later(message)
  end
end
