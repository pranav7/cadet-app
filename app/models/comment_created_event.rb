class CommentCreatedEvent < ApplicationRecord
  belongs_to :company
  belongs_to :post

  belongs_to :comment, dependent: :destroy

  def activity_log
    ActivityLog.find_by(
      company_id: company.id,
      post_id: post.id,
      event_id: id,
      event_type: Constants::EventTypes::COMMENT_CREATED
    )
  end
end
