require 'rails_helper'

describe Votes::Create do
  let(:voter) { create :user }
  let(:company) { create :company }
  let(:post) { create :post }

  subject { described_class.run!(post: post, voter: voter) }

  before do
    Current.company = company
  end

  context "when current user is the voter" do
    before do
      Current.user = voter
    end

    it "creates a vote" do
      subject
      expect(voter.voted?(post)).to eq(true)
    end

    it "adds the user to the company post belongs to" do
      expect(voter.companies.include?(company)).to eq(false)
      subject
      expect(voter.companies.include?(company)).to eq(true)
    end
  end

  context "when current user is not the voter" do
    before do
      Current.user = admin
    end

    context "when admin has permissions" do
      let(:admin) { create :admin, company: company }

      it "creates a vote and with the correct details" do
        subject
        vote = post.votes.reload.find_by(user_id: voter.id)
        expect(vote.added_by).to eq(admin)
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
