class Content < ApplicationRecord
  belongs_to :parent, polymorphic: true, optional: true

  validates :body, presence: true
end
