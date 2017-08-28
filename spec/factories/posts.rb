FactoryGirl.define do
  factory :post do
    title "MyString"
    status 1

    after :create do |post|
      post.content = create(:content, parent: post)
    end
  end
end
