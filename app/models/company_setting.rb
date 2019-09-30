class CompanySetting < ApplicationRecord
  belongs_to :company
  validates :intercom_workspace_id, uniqueness: true
end
