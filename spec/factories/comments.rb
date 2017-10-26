FactoryGirl.define do
  factory :comment do
    user
    post
    content_attributes {{ body: "Comment Content" }}
  end
end
