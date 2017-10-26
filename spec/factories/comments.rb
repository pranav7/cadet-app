FactoryGirl.define do
  factory :comment do
    user
    content_attributes {{ body: "Comment Content" }}
  end
end
