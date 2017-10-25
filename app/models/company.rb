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

  after_commit :notify_slack, on: :create

  def customers
    memberships.where(role: :customer).map(&:user)
  end

  def admins
    memberships.where(role: :admin).map(&:user)
  end

  def notify_slack
    return if Rails.env.test?

    message = "*A Company was added*"
    message << "\n#{self.name} - http://#{self.subdomain}.getcadet.com/"

    client = Slack::Web::Client.new
    client.chat_postMessage(channel: '#main', text: message, as_user: true)
  end
end
