class VoteSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id
  belongs_to :user
end
