class User < ApplicationRecord
  enum role: [:admin, :customer]

  has_many :posts
  has_many :comments
  has_many :votes
  has_many :memberships
  has_many :companies, through: :memberships

  accepts_nested_attributes_for :memberships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  validates :first_name, presence: true
  validates :email,
    uniqueness: true,
    presence: true,
    format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

  def name
    [first_name, last_name].join(" ")
  end

  def voted?(post)
    return false if votes.where(post: post).empty?
    return true
  end
end
