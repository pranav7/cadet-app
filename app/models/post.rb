class Post < ApplicationRecord
  has_one :content, as: :parent
  has_many :comments
  belongs_to :user, optional: true # @todo Remove optional later

  validates :title, presence: true

  accepts_nested_attributes_for :content
end
