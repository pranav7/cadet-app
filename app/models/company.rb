class Company < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  validates :subdomain,
    uniqueness: true,
    presence: true,
    exclusion: { in: %w(app), message: "This subdomain is not available" }

  validates :name, presence: true
end
