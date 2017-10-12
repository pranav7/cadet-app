class Account < ApplicationRecord
  belongs_to :company

  has_many :account_memberships
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
    return [] unless board

    users.collect do |user|
      user.voted_posts.where(board: board)
    end.flatten.uniq
  end
end
