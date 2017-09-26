class Account < ApplicationRecord
  belongs_to :company

  has_many :account_memberships
  has_many :users, through: :account_memberships

  # Get all the votes that an account's users have voted for a given post
  def votes_for(post)
    users.map { |user| user.votes.where(post: post) }.flatten.uniq
  end

  # Get all the posts that an account's users have voted on
  def posts
    users.collect { |user| user.voted_posts }.flatten.uniq
  end
end
