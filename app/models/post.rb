class Post < ApplicationRecord
  has_one :content
  has_many :comments
  belongs_to :user
end
