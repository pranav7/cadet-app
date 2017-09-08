require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create :user }

  before :each do
    request.host = "#{user.companies.first.subdomain}.example.com"
    sign_in user
  end

  describe "#create" do
    let(:_post) { create :post, company: user.companies.first }

    it "creates a vote" do
      expect {
        post :create, params: { post_id: _post.id }
      }.to change(Vote, :count).by(1)
    end
  end

  describe "#destroy" do
    let(:_post) { create :post, company: user.companies.first }
    let(:vote) { create :vote, post: _post, user: user }

    it "deletes vote" do
      delete :destroy, params: { post_id: _post.id }
      expect(Vote.where(id: vote.id)).to be_empty
    end
  end
end
