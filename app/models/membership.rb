class Membership < ApplicationRecord
  enum role: { customer: 0, admin: 20 }

  belongs_to :user
  belongs_to :company

  validates_presence_of :user
  validates_presence_of :company

  accepts_nested_attributes_for :company
end
