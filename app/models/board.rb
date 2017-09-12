class Board < ApplicationRecord
  belongs_to :company
  has_many :posts
end
