class Board < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:scoped, :slugged, :history], scope: :company

  belongs_to :company
  has_many :posts

  validates :slug, presence: true, uniqueness: { scope: :company }
  validates :name, uniqueness: { case_sensitive: false, scope: :company }

  alias_attribute :title, :name
end
