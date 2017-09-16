class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  has_one :content, as: :parent
  has_many :comments

  has_many :votes
  has_many :voters, through: :votes, source: :user

  belongs_to :user, optional: true # @todo Remove optional later
  belongs_to :board

  validates :title, presence: true

  accepts_nested_attributes_for :content

  enum status: %w(open planned developing released closed)
end
