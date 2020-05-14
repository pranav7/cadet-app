FactoryGirl.define do
  factory :comment_created_event do
    post
    company
    comment
  end
end
