class ChangelogEntry < ApplicationRecord
  include ChronologicalScopes
  extend FriendlyId

  belongs_to :company

  friendly_id :title, use: [:scoped, :slugged, :history], scope: :company

  validates :title, presence: true
  validates :status, presence: true
  validates :slug, presence: true, uniqueness: { scope: :company }

  has_one :content, as: :parent, dependent: :destroy
  accepts_nested_attributes_for :content
end
