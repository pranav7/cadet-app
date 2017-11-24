require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :admin, company: company }
  let(:board) { create :board, company: company }

  before :each do
    request.host = "#{company.subdomain}.example.com"
    sign_in user
  end

  describe "#update" do
    let(:post) { create :post, board: board }

    it "updates the post" do
      expect(post.closed?).to eq(false)

      put :update, params: { board_id: board.id, id: post.id, post: { status: "closed" } }
      
      post.reload
      expect(post.closed?).to eq(true)
    end
  end

  describe "#destroy" do
    let(:post) { create :post, board: board }

    it "destroys the post and all it's comments and votes" do
      vote = create :vote, post: post
      comment = create :comment, post: post

      delete :destroy, params: { board_id: board.id, id: post.id }

      lambda {
        expect(Post.find(post.id)).to raise_exception(ActiveRecord::RecordNotFound)
        expect(Comment.find(comment.id)).to raise_exception(ActiveRecord::RecordNotFound)
        expect(Vote.find(vote.id)).to raise_exception(ActiveRecord::RecordNotFound)
      }
    end
  end
end
