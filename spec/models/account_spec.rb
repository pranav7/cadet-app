require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "Validations" do
    it { should belong_to(:company) }
    it { should have_many(:account_memberships) }
    it { should have_many(:users).through(:account_memberships) }
  end

  describe "#votes_for" do
    let(:post) { create :post }
    let(:user1) { create :user }
    let(:user2) { create :user }
    let(:account) { create :account }

    before :each do
      @votes = []

      [user1, user2].each do |user|
        create(:account_membership, user: user, account: account)
        @votes << create(:vote, post: post, user: user)
      end
    end

    it "returns the votes created by the users of an account" do
      expect(account.votes_for(post).map(&:id).sort).to eq(@votes.map(&:id).sort)
    end
  end
end
