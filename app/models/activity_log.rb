class ActivityLog < ApplicationRecord
  enum visibility: { PRIVATE: 'private', PUBLIC: 'public' }
  enum status: %w[]
  belongs_to :company
  belongs_to :post
end
