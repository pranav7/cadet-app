FactoryGirl.define do
  factory :post do
    title "My Awesome Post Title"
    board

    after :create do |post|
      post.content = create(:content, parent: post)
    end
  end
end
