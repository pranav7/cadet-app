class Content < ApplicationRecord
  belongs_to :parent, polymorphic: true

  validates :body, presence: true
end
