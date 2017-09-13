class Board < ApplicationRecord
  include Sluggable

  belongs_to :company
  has_many :posts

  alias_attribute :title, :name
end
