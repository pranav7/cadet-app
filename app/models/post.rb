class Post < ApplicationRecord
  include ChronologicalScopes
  extend FriendlyId

  friendly_id :title, use: [:scoped, :slugged, :history], scope: :board

  enum status: %w(open planned developing released closed)

  scope :latest_activity, -> { order(last_activity_at: :desc).where.not(status: :closed) }
  scope :most_voted, -> { left_joins(:votes).group(:id).order('COUNT(votes.id) DESC').where.not(status: ["released", "closed"]) }
  scope :show_all, -> { order(last_activity_at: :desc) }
  scope :most_recent, -> { order(created_at: :desc) }

  has_one :content, as: :parent, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  belongs_to :requester,
    class_name: "User",
    optional: true,
    foreign_key: "user_id"
  belongs_to :board
  # If created by an Admin on behalf of a Customer
  belongs_to :added_by, class_name: "User", optional: true

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { scope: :board }

  accepts_nested_attributes_for :content

  before_validation :set_last_activity_at, on: :create
  after_create :perform_after_create_tasks
  after_save :perform_after_update_tasks, on: :update

  class << self
    def sorted(options = {})
      default_sort_method = :latest_activity
      if board = options.delete(:board)
        default_sort_method = board.default_sort_order.to_sym if board.default_sort_order
      end

      sort_method = options.delete(:sort_method) || default_sort_method
      self.public_send(sort_method)
    end

    def status_collection
      collection = {}
      statuses.map do |key, value|
        collection["##{key}"] = key
      end

      collection
    end

    def search(term:)
      where(Post.arel_table[:title].matches("%#{term.downcase}%"))
    end
  end

  def commenters
    comments.map(&:user)
  end

  # Methods added to support
  # backward compatibility of user relationship
  # which is now requester
  # @todo remove this
  def user
    requester
  end

  def user=(x)
    requester = x
  end

  def company
    board.company
  end

  def all_participants
    (voters + commenters).flatten.uniq
  end

  def participants
    (manual_voters + commenters + [requester]).flatten.compact.uniq.reject do |participant|
      participant == Current.user ||
        not(BoardPolicy.new(user: participant, resource: board).accessible?)
    end
  end

  # Get all the accounts whose users have upvoted this post
  def accounts
    voters.map { |voter| voter.account_for(board.company) }.uniq.compact
  end

  def perform_after_update_tasks
    if saved_change_to_status?
      update_last_activity_at
      notify_status_changed_to_all_participants(saved_change_to_status.last)
    end
  end

  def perform_after_create_tasks
    notify_post_created_to_all_admins
    notify_slack
  end

  def notify_post_created_to_all_admins
    company.admins.each do |admin|
      next if admin == requester
      PostNotificationMailer.new_post(self, admin).deliver_later
    end
  end

  def notify_status_changed_to_all_participants(status)
    participants.each do |participant|
      PostNotificationMailer.status_changed(self, status, participant).deliver_later
    end
  end

  def manual_voters
    votes.manual.map(&:user)
  end

  def summary
    content.body.truncate(200)
  end

  private
    def set_last_activity_at
      self.last_activity_at = Time.zone.now
    end

    def update_last_activity_at
      self.touch :last_activity_at
    end

    def notify_slack
      return if Rails.env.test?

      message = "*New Post - ##{board.company.subdomain}*"
      message << "\n#{requester.formatted_address} posted _#{title}_ in #{board.name}"

      NotifySlackJob.perform_later(message)
    end
end
