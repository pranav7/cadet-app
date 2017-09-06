class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :company

  validates_presence_of :user
  validates_presence_of :company

  accepts_nested_attributes_for :company
end
