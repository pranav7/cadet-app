class Membership < ApplicationRecord
  enum role: { customer: 0, admin: 20 }

  belongs_to :user
  belongs_to :company

  validates :user,
            presence: true,
            uniqueness: { scope: :company_id, message: "A user with this email already exists" },
            case_sensetive: false

  validates :company, presence: true

  accepts_nested_attributes_for :company
end
