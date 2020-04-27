require 'rails_helper'

describe Posts::Update do
  let(:company) { create :company }
  let(:user) { create :admin, company: company }
  let(:board) { create :board, company: company }
  let(:post) { create :post, status: 0 }

  subject { described_class.run!(post: post, status: 2, title: nil, user_id: nil, content: nil) }

  before do
    Current.user = user
    Current.company = company
  end

  context "When current user change the status" do
    it "Updates the status" do
      subject
      expect(post.developing?).to eq(true)
    end
  end
end