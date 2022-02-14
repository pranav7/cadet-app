class Company < ApplicationRecord
  include Lightning::Flaggable

  has_many :memberships
  has_many :users, through: :memberships
  has_many :boards
  has_many :accounts
  has_many :changelog_entries
  has_one :company_setting

  before_save :downcase_subdomain, on: :create
  after_commit :post_create_tasks, on: :create

  validates :subdomain,
            uniqueness: true,
            presence: true,
            format: { with: /\A[a-zA-Z0-9\-_]*$\z/, message: "This subdomain is invalid" },
            exclusion: { in: %w[app], message: "This subdomain is not available" }

  validates :name, presence: true

  def cadet_app?
    subdomain == "feedback"
  end

  def customers
    memberships.where(role: :customer).map(&:user).compact
  end

  def admins
    memberships.where(role: :admin).map(&:user).compact
  end

  def owner
    memberships.where(owner: true).first.try(:user)
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

    if active_users_count > pricing_plan.per_user_modulus
      pricing_plan.base_price + ((active_users_count / pricing_plan.per_user_modulus) * pricing_plan.per_user_price)
    else
      pricing_plan.base_price
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

  def create_sample_board_and_post
    board = boards.create(
      title: "Feature Requests",
      description: "Let us know your feedback or feature requests"
    )

    board.posts.create(
      title: "Getting started",
      user_id: owner.id,
      content_attributes: {
        body: "To help you get started we've created this sample post. Posts can have rich formatting through [markdown](https://guides.github.com/features/mastering-markdown/).\r\n\r\n**You can do the following things with ease:**\r\n- Format with bullet point\r\n- Easily share links\r\n- Tag others in comments/notes through @mentions to send them a notification email\r\n\r\nYou can also share code snippets, this particularly comes in handy when you create boards to capture bug reports.\r\n\r\n```js\r\nconsole.log(\"Hello, there!\");\r\n```"
      }
    )
  end

  def pricing_plan
    Pricing::Plan.new(version: company_setting.pricing_version)
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

    NotifySlackJob.perform_later(message, channel: "#new-signups")
  end

  def downcase_subdomain
    self.subdomain = subdomain.downcase
  end

  def create_company_setting
    company_setting = build_company_setting
    company_setting.expires_at = Pricing::Plan::TRIAL_PERIOD.days.from_now
    company_setting.billing_plan = "trial"
    company_setting.pricing_version = Pricing::Plan::ACTIVE_VERSION
    company_setting.save!
  end
end
