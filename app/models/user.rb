class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :votes
  has_many :voted_posts, through: :votes, source: :post
  has_many :memberships
  has_many :companies, through: :memberships
  has_many :account_memberships
  has_many :accounts, through: :account_memberships
  # has_one_attached :image

  accepts_nested_attributes_for :memberships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :first_name, presence: true
  validates :email,
    uniqueness: true,
    presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

  after_commit :notify_slack, on: :create

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.google_oauth2_data"] && session["devise.google_oauth2_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def name
    [first_name, last_name].join(" ")
  end

  def name=(name)
    self.first_name, self.last_name = name.split(" ")
  end

  def initials
    "#{first_name.slice(0, 1)}#{last_name.slice(0, 1)}".upcase
  end

  def voted?(post)
    return false if votes.where(post: post).empty?
    return true
  end

  # @todo Add Test
  def make_admin!(company)
    memberships.where(company: company).first.admin!
  end

  def admin_of?(company)
    return false if memberships.where(company: company, role: :admin).empty?
    return true
  end

  def customer_of?(company)
    return false if memberships.where(company: company, role: :customer).empty?
    return true
  end

  def part_of?(company)
    return false if memberships.where(company: company).empty?
    return true
  end

  def account_for(company)
    accounts.where(company: company).first
  end

  # @todo Write spec for this
  def notify_slack
    return if Rails.env.test?

    message = "*#{self.name} (#{self.email}) signed up!*"
    if self.job_title
      message << "\n_#{self.job_title}_"
    end
    # message << "\n#{self.companies.first.name} - http://#{self.companies.first.subdomain}.getcadet.com/"
    # message << "\n`#{self.memberships.first.role}`"

    client = Slack::Web::Client.new
    client.chat_postMessage(channel: '#main', text: message, as_user: true)
  end
end
