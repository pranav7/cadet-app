class CommentCreatedEvent < ApplicationRecord
    belongs_to :company
    belongs_to :post
  end
