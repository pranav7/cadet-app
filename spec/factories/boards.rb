FactoryGirl.define do
  factory :board do
    company
    sequence(:name) { |n| "Board #{n}" }
    description "A list of popular feature requests from our customers"

    trait :roadmap_disabled do
      roadmap_enabled { false }
    end

    trait :private do
      private { true }
    end
  end
end
