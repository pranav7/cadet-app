FactoryGirl.define do
  factory :membership do
    user
    company
  end

  factory :admin_membership, parent: :membership do
    role "admin"
  end
end
