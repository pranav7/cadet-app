class User < ApplicationRecord
  has_many :posts
  has_many :comments

  has_many :votes
  has_many :voted_posts, through: :votes, source: :post

  has_many :memberships, dependent: :destroy
  has_many :companies, through: :memberships

  has_many :account_memberships, dependent: :destroy
  has_many :accounts, through: :account_memberships
  # has_one_attached :image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  
  before_create :set_username
  after_commit :notify_slack, on: :create
  after_invitation_accepted :notify_slack_invite_accepted
  after_invitation_created :notify_slack_invite_created

  accepts_nested_attributes_for :memberships

  validates :username, uniqueness: true
  validates :first_name, presence: true
  validates :email,
    uniqueness: true,
    presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

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

  def formatted_address
    require 'mail'

    address = Mail::Address.new email
    address.display_name = name.dup
    address.format
  end

  def name
    [first_name, last_name].join(" ")
  end

  def name=(name)
    self.first_name, self.last_name = name.split(" ")
  end

  def initials
    first_name.slice(0, 1).upcase
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

  def membership_for(company)
    memberships.where(company: company).first
  end

  def primary_company
    membership = memberships.where(primary: true).first
    return membership.company if membership
  end

  def notify_slack
    return if Rails.env.test?
    return if invited_to_sign_up?

    message = "*#{formatted_address}* is now on Cadet"
    NotifySlackJob.perform_later(message)
  end

  def notify_slack_invite_accepted
    return if Rails.env.test?

    message = "*#{formatted_address}* accepted the invite for *#{memberships.first.company.subdomain}*"
    NotifySlackJob.perform_later(message)
  end

  def notify_slack_invite_created
    return if Rails.env.test?

    message = "*#{formatted_address}* was invited to *#{memberships.first.company.subdomain}* as _#{memberships.first.role.titleize}_ by *#{invited_by.formatted_address}*"
    NotifySlackJob.perform_later(message)
  end

  def set_username
    self.username = create_username
  end

  private
    def create_username
      username = name.parameterize
      taken_usernames = User.where("username LIKE ?", "#{username}%").pluck(:username)

      return username unless taken_usernames.include?(username)

      count = 1
      while true
        new_username = "#{username}-#{count}"
        return new_username unless taken_usernames.include?(new_username)
        count += 1
      end
    end
end
