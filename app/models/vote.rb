class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :added_by, class_name: "User", optional: true

  validates_presence_of :user
  validates_presence_of :post

  after_create :touch_post_last_activity

  scope :manual, -> { where(added_by: nil) }

  def manual?
    !!!added_by
  end

  private

  def touch_post_last_activity
    post.touch(:last_activity_at)
  end
end
