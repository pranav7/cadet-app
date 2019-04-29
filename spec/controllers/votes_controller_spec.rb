require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create :user }
  let(:company) { create :company }
  let(:board) { create :board, company: company }

  before :each do
    request.host = "#{company.subdomain}.example.com"
    sign_in user
  end

  describe "POST create" do
    let(:_post) { create :post, board: board }

    it "creates a vote" do
      expect {
        post :create, params: { board_id: board.id, post_id: _post.id }
      }.to change(Vote, :count).by(1)
    end

    it "adds the user to the company post belongs to" do
      expect(user.companies.include?(company)).to eq(false)

      post :create, params: { board_id: board.id, post_id: _post.id }

      expect(user.companies.include?(company)).to eq(true)
    end
  end

  describe "DELETE destroy" do
    let(:_post) { create :post, board: board }
    let!(:vote) { create :vote, post: _post, user: user }

    it "deletes vote" do
      delete :destroy, params: { board_id: board, post_id: _post.id }
      expect(Vote.where(id: vote.id)).to be_empty
    end
  end
end
