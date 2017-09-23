class Account < ApplicationRecord
  belongs_to :company

  has_many :account_memberships
  has_many :users, through: :account_memberships
end
