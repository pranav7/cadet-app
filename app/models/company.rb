class Company < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
  has_many :boards
  has_many :accounts
  has_one :company_setting

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

  def active_users
    active_users = posts.map(&:requester)
    active_users << posts.map(&:voters)
    active_users << posts.map(&:comments).flatten.map(&:commenter)

    active_users.flatten.uniq
  end

  def posts
    boards.map(&:posts).flatten
  end

  def host
    "#{subdomain}.#{APP_CONFIG['base_domain']}"
  end

  def paying?
    company_setting.expires_at.nil?
  end

  def expired?
    return false unless company_setting.expires_at

    Time.zone.now > company_setting.expires_at
  end

  private
    def post_create_tasks
      notify_slack
      create_company_setting
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

    def create_company_setting
      company_setting = build_company_setting
      company_setting.expires_at = 14.days.from_now
      company_setting.billing_plan = "trial"
      company_setting.pricing_version = "v1"
      company_setting.save!
    end
end
