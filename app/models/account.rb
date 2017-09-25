class Account < ApplicationRecord
  belongs_to :company

  has_many :account_memberships
  has_many :users, through: :account_memberships

  def votes_for(post)
    users.map { |user| user.votes.where(post: post) }.flatten.uniq
  end
end
