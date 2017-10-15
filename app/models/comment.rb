class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :content, as: :parent

  accepts_nested_attributes_for :content

  after_create :touch_post_last_activity

  private

  def touch_post_last_activity
    post.touch(:last_activity_at)
  end
end
