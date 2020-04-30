FactoryGirl.define do
  factory :activity_log do
    post
    company

    trait :status_changed do
      event_type { Constants::EventTypes::STATUS_CHANGED }
      event_id { create(:status_changed_event).id }
      visibility { Constants::Visibility::PUBLIC }
    end
  end
end
