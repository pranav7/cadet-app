FactoryGirl.define do
  factory :activity_log do
    post
    company

    trait :status_changed do
      event_type { Constants::EventTypes::STATUS_CHANGED }
      event_id { create(:status_changed_event, company: company, post: post).id }
      visibility { Constants::Visibility::PUBLIC }
    end

    trait :comment_created_event do
      event_type { Constants::EventTypes::COMMENT_CREATED }
      event_id { create(:comment_created_event, company: company, post: post).id }
      visibility { Constants::Visibility::PUBLIC }
    end
  end
end
