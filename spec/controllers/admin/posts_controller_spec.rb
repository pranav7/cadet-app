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
end
