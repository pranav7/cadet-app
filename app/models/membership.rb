class Membership < ApplicationRecord
  enum role: { customer: 0, admin: 20 }

  belongs_to :user
  belongs_to :company

  validates :user, presence: true
  validates :company, presence: true

  accepts_nested_attributes_for :company
end
