class CommentCreatedEvent < ApplicationRecord
  belongs_to :company
  belongs_to :post

  belongs_to :comment, dependent: :destroy

  def serializer
    'partials/comment_created_event'
  end
end
