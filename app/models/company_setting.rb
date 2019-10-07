class CompanySetting < ApplicationRecord
  belongs_to :company
  validates :intercom_workspace_id, uniqueness: true, allow_nil: true

  before_create :generate_api_key

  def generate_api_key
    self.api_key = loop do
      token = SecureRandom.hex(16)
      break token unless self.class.exists?(api_key: token)
    end
  end
end
