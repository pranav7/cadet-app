FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }

    sequence :subdomain do |n|
      "#{name.parameterize}-#{n}"
    end
  end
end
