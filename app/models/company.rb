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
    # Return all users who have created a post
    active_users = users.joins(:posts).where(posts: posts).uniq
    # Return all users who have upvoted a post
    active_users << users.joins(:votes).uniq
    # Return all users who have commented on a post
    active_users << users.joins(:comments).uniq

    active_users.flatten.uniq
  end

  def posts
    Post.joins(:board).where(board: boards)
  end

  def host
    "#{subdomain}.#{APP_CONFIG['base_domain']}"
  end

  def current_monthly_bill
    active_users_count = active_users.count

    if active_users_count > 100
      29 + ((active_users_count / 100) * 9)
    else
      29
    end
  end

  def in_trial?
    company_setting.billing_plan == "trial"
  end

  def paying?
    company_setting.expires_at.nil? || (company_setting.billing_plan == "basic")
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

    message = "*##{subdomain} signed up*"
    message << "\n_Name:_ #{name}"
    message << "\n_Admin:_ #{memberships.first.user.formatted_address}"

    NotifySlackJob.perform_later(message, channel: "#main")
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
