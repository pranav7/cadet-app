class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :added_by, class_name: "User", optional: true

  validates_presence_of :user
  validates_presence_of :post

  after_create :touch_post_last_activity
  after_commit :post_create_tasks, on: :create

  scope :manual, -> { where(added_by: nil) }

  def manual?
    !!!added_by
  end

  def post_create_tasks
    notify_slack
  end

  def voter
    user
  end

  private

  def touch_post_last_activity
    post.touch(:last_activity_at)
  end

  def notify_slack
    return if Rails.env.test?

    message = "*New Upvote - ##{post.company.subdomain}*"
    message << "\n*#{voter.formatted_address}* upvoted *#{post.title}* in #{post.board.name}"

    NotifySlackJob.perform_later(message)
  end
end
