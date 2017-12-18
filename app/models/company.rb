class Company < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
  has_many :boards
  has_many :accounts

  before_save :downcase_subdomain, on: :create
  after_commit :post_create_tasks, on: :create

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

  private

  def post_create_tasks
    notify_slack
  end

  def notify_slack
    return if Rails.env.test?

    message = "*##{subdomain} is now on Cadet*"
    message << "\n_Name:_ #{name}"
    message << "\n_Admin:_ #{memberships.first.user.formatted_address}"

    NotifySlackJob.perform_later(message)
  end

  def downcase_subdomain
    self.subdomain = subdomain.downcase
  end
end
