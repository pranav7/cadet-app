class StatusChangedEvent < ApplicationRecord
  belongs_to :company
  belongs_to :post

  def changed_by
    User.find(admin_id)
  end

  def serializer
    'partials/status_changed_event'
  end
end
