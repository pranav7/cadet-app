class Post < ApplicationRecord
  has_one :content, as: :parent
  has_many :comments
  belongs_to :user
end
