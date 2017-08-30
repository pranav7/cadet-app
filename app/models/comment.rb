class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true
  has_one :content

  accepts_nested_attributes_for :content
end
