class Company < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
  has_many :boards
  has_many :accounts

  validates :subdomain,
    uniqueness: true,
    presence: true,
    format: { with: /\A[a-zA-Z0-9\-_]*$\z/, message: "This subdomain is invalid" },
    exclusion: { in: %w(app), message: "This subdomain is not available" }

  validates :name, presence: true

  def customers
    memberships.where(role: :customer).map(&:user)
  end

  def admins
    memberships.where(role: :admin).map(&:user)
  end

  def host
    "#{subdomain}.#{APP_CONFIG['base_domain']}"
  end
end
