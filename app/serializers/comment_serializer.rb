class CommentSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :created_at

  belongs_to :user
  has_one :content

  attribute :type do |object|
    object.note? ? "note" : "comment"
  end
end
