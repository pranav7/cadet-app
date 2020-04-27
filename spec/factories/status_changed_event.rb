FactoryGirl.define do
  factory :status_changed_event do
    post
    company
    old_value Post.status[:open]
    new_value Post.status[:developing]
  end
end
