class Board < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history, :scoped], scope: :company

  belongs_to :company
  has_many :posts

  alias_attribute :title, :name
end
