FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    transient do
      company nil
    end

    after :create do |user, evaluator|
      if evaluator.company
        user.companies << evaluator.company
      else
        user.companies << create(:company)
      end
    end
  end

  factory :admin, parent: :user do
    after :create do |user, evaluator|
      if evaluator.company
        create :admin_membership, company: evaluator.company, user: user
      end
    end
  end
end
