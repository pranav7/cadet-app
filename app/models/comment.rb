class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_one :content, as: :parent

  accepts_nested_attributes_for :content
end
