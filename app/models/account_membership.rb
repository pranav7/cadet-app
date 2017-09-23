class AccountMembership < ApplicationRecord
  belongs_to :user
  belongs_to :account

  validates :user, presence: true
  validates :account, presence: true
end
