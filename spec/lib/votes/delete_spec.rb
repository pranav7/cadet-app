require 'rails_helper'

describe Votes::Delete do
  let(:company) { create :company }
  let(:post) { create :post }
  let(:voter) { create :user }

  subject { described_class.run!(post: post, voter: voter) }

  before do
    Current.company = company
    create :vote, post: post, user: voter
  end

  context "when current user is the voter" do
    before do
      Current.user = voter
    end

    it "removes the vote" do
      expect(voter.voted?(post)).to eq(true)
      subject
      expect(voter.voted?(post)).to eq(false)
    end
  end

  context "when current user is not the voter" do
    before do
      Current.user = admin
    end

    context "when admin has permissions" do
      let(:admin) { create :admin, company: company }

      it "creates a vote and with the correct details" do
        expect(voter.voted?(post)).to eq(true)
        subject
        expect(voter.voted?(post)).to eq(false)
      end
    end

    context "when admin does not have permission" do
      let(:admin) { create :admin }

      it "creates a vote and with the correct details" do
        expect { subject }.to raise_error(Errors::AdminLacksPermission)
      end
    end
  end
end
