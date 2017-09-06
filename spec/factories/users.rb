FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    transient do
      company create(:company)
    end

    after :create do |user, evaluator|
      user.companies << evaluator.company
    end
  end

  factory :admin, parent: :user do
    role "admin"
  end

  factory :customer, parent: :user do
    role "customer"
  end
end
