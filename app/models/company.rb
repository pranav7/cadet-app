class Company < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  validates :subdomain, uniqueness: true, presence: true
  validates :name, presence: true
end
