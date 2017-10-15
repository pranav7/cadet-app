FactoryGirl.define do
  factory :comment do
    user

    after :create do |comment|
      comment.content = create(:content, parent: comment)
    end
  end
end
