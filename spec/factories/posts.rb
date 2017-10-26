FactoryGirl.define do
  factory :post do
    title "My Awesome Post Title"
    board
    content_attributes {{ body: "Post Content" }}
  end
end
