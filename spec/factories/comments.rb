FactoryGirl.define do
  factory :comment do
    after :create do |comment|
      comment.content = create(:content, parent: comment)
    end
  end
end
