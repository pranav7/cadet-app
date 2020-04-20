class PostSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :slug, :title, :status, :created_at

  belongs_to :user
  has_one :content
  has_many :comments
  has_many :votes

  attribute :votes_count do |object|
    object.votes.count
  end
end
