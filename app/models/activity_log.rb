class ActivityLog < ApplicationRecord
  belongs_to :company
  belongs_to :post

  scope :public_activity, -> { where(visibility: Constants::Visibility::PUBLIC) }

  def event
    Constants::EventTypes::CLASSES[event_type].find(event_id)
  end
end
