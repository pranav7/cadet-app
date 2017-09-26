FactoryGirl.define do
  factory :account do
    name { Faker::Company.name }
    domain { Faker::Internet.domain_name }
    company
    paying false
    churned false
    mrr 49
  end

  factory :paying_account, parent: :account do
    paying true
  end

  factory :churned_account, parent: :account do
    churned true
  end
end
