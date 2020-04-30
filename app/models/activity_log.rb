class ActivityLog < ApplicationRecord
  belongs_to :company
  belongs_to :post

  def event
    Constants::EventTypes::CLASSES[event_type].find(event_id)
  end
end
