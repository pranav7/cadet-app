require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create :user }
  let(:company) { create :company }

  before :each do
    request.host = "#{company.subdomain}.example.com"
    sign_in user
  end

  describe "#create" do
    let(:_post) { create :post, company: company }

    it "creates a vote" do
      expect {
        post :create, params: { post_id: _post.id }
      }.to change(Vote, :count).by(1)
    end

    it "adds the user to the company post belongs to" do
      expect(user.companies.include?(company)).to eq(false)

      post :create, params: { post_id: _post.id }

      expect(user.companies.include?(company)).to eq(true)
    end
  end

  describe "#destroy" do
    let(:_post) { create :post, company: company }
    let!(:vote) { create :vote, post: _post, user: user }

    it "deletes vote" do
      delete :destroy, params: { post_id: _post.id }
      expect(Vote.where(id: vote.id)).to be_empty
    end
  end
end
