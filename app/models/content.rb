class Content < ApplicationRecord
  belongs_to :parent, polymorphic: true
end
