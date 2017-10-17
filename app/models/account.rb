class Account < ApplicationRecord
  belongs_to :company

  has_many :account_memberships, dependent: :destroy
  has_many :users, through: :account_memberships

  validates :name, presence: true
  validates :domain, presence: true
  validates :mrr, presence: true

  # Get all the votes that an account's users have voted for a given post
  def votes_for(post)
    users.map { |user| user.votes.where(post: post) }.flatten.uniq
  end

  # Get all the posts that an account's users have upvoted
  def posts(board = nil)
    Post.joins(:votes).where(votes: { user: users }).distinct
  end
end
