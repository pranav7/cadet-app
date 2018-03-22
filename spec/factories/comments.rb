FactoryGirl.define do
  factory :comment do
    post
    association :commenter, factory: :user
    content_attributes {{ body: "Comment Content" }}
  end
end
