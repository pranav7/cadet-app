class Comment < ApplicationRecord
  include ChronologicalScopes

  belongs_to :post
  belongs_to :commenter, class_name: "User", foreign_key: "user_id"
  has_one :content, as: :parent

  accepts_nested_attributes_for :content

  after_create :touch_post_last_activity
  after_commit :send_notifications, on: :create

  scope :without_notes, -> { where.not(private: true) }

  class << self
    def create_from_email(email, post, options = {})
      is_private = options.delete(:private) || false

      user = User.find_by!(email: email.From)
      Comment.create(commenter: user, post: post, private: is_private,
                     content_attributes: { body: email.StrippedTextReply })
    end
  end

  def note?
    !!private
  end

  def user
    commenter
  end

  def send_notifications
    notify_mentionees
    notify_admins unless commenter.admin_of? post.company
    notify_requester if should_notify_requester?

    notify_slack
  end

  def notify_mentionees
    mentionees.each do |mentionee|
      next unless should_notify_mentionee?(mentionee)
      CommentNotificationMailer.mention(self, mentionee).deliver_later
    end
  end

  def notify_admins
    post.company.admins.each do |admin|
      next if admin == commenter
      next if mentionees.include?(admin)

      CommentNotificationMailer.new_comment(self, admin).deliver_later
    end
  end

  def notify_requester
    CommentNotificationMailer.new_comment(self, post.requester).deliver_later
  end

  private
  def should_notify_mentionee?(mentionee)
    if note? && !mentionee.admin_of?(post.company)
      return false
    elsif mentionee == commenter
      return false
    elsif !BoardPolicy.new(user: mentionee, resource: post.board).accessible?
      return false
    end

    true
  end

  def touch_post_last_activity
    post.touch(:last_activity_at)
  end

  def should_notify_requester?
    !note? &&
      staff_commented? &&
      requester_not_admin? &&
      requester_not_mentioned? &&
      !post.board.private?
  end

  def staff_commented?
    commenter.admin_of?(post.company)
  end

  def requester_not_admin?
    !post.requester.admin_of?(post.company)
  end

  def requester_not_mentioned?
    !mentionees.include?(post.requester)
  end

  def notify_slack
    return if Rails.env.test?

    comment_type = note? ? "Note" : "Comment"
    message = "*New #{comment_type} - ##{post.company.subdomain}*"
    message << "\n#{commenter.formatted_address} commented on _#{post.title}_ in #{post.board.name}"

    NotifySlackJob.perform_later(message)
  end

  def mentionees
    mentions = []
    content.body.scan(/(?<!\w)@([a-z0-9-]+)?/) do |username|
      user = User.find_by_username(username)
      mentions.unshift user
    end

    mentions.compact
  end
end
