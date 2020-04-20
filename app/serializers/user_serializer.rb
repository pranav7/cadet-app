class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :initials
  attribute :role do |object|
    object.membership_for(Current.company).role
  end
end
