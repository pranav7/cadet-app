class Post < ApplicationRecord
  has_one :content
  belongs_to :user
end
