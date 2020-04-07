require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create :user }
  let(:company) { create :company }
  let(:board) { create :board, company: company }

  before :each do
    request.host = "#{company.subdomain}.example.com"
    sign_in(user)
  end

  describe "POST create" do
    let(:_post) { create :post, board: board }

    it "creates a vote" do
      expect(Votes::Create)
        .to receive(:run)
        .with(post: _post, voter: user)
      post :create, params: { board_id: board.id, post_id: _post.id }
    end

    context "when params[:user_id] is passed" do
      let(:user_2) { create :user }

      it "finds the correct user" do
        expect(Votes::Create)
          .to receive(:run)
          .with(post: _post, voter: user_2)
        post :create, params: { board_id: board.id, post_id: _post.id, user_id: user_2.id }
      end
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
