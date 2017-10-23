class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:scoped, :slugged, :history], scope: :board

  scope :latest_activity, -> { order(last_activity_at: :desc).where.not(status: :closed) }
  scope :sort_by_new, -> { order(created_at: :desc) }
  scope :most_voted, -> { left_joins(:votes).group(:id).order('COUNT(votes.id) DESC') }
  scope :show_all, -> { order(last_activity_at: :desc) }

  has_one :content, as: :parent
  has_many :comments, dependent: :destroy

  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  belongs_to :user, optional: true # @todo Remove optional later
  belongs_to :board

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: { scope: :board }

  accepts_nested_attributes_for :content

  enum status: %w(open planned developing released closed)

  before_validation :set_last_activity_at, on: :create

  def self.sorted(options = {})
    sort_method = options.delete(:sort_method) || :latest_activity

    self.public_send(sort_method)
  end

  def created_by
    user
  end

  # Get all the accounts whose users have upvoted this post
  def accounts
    voters.map { |voter| voter.account_for(board.company) }.uniq.compact
  end

  private

  def set_last_activity_at
    self.last_activity_at = Time.zone.now
  end
end
