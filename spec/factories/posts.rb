FactoryGirl.define do
  factory :post do
    title "My Awesome Post Title"
    board
    content_attributes { { body: "Post Content" } }
    
    trait :planned do
      status Post.statuses[:planned]
    end

    trait :developing do
      status Post.statuses[:developing]
    end

    trait :released do
      status Post.statuses[:released]
    end
  end
end
