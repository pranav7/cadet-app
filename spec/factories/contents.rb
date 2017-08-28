FactoryGirl.define do
  factory :content do
    body "MyText"
  end

  factory :content_for_post, parent: :content do
    association :parent, factory: :post
  end
end
