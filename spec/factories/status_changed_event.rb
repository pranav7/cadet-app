FactoryGirl.define do
  factory :status_changed_event do
    post
    company
    old_value Post.statuses[:open]
    new_value Post.statuses[:developing]
  end
end
