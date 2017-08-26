class Company < ApplicationRecord
  has_many :users

  validates :subdomain, uniqueness: true, presence: true
  validates :name, presence: true
end
