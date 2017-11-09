FactoryGirl.define do
  factory :board do
    company
    sequence(:name) { |n| "Board #{n}" }
    description "A list of popular feature requests from our customers"
  end
end
