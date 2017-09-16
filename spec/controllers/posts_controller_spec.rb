require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:board) { create :board, company: company }

  before :each do
    request.host = "#{company.subdomain}.example.com"
    sign_in user
  end

  describe "#create" do
    let(:content_params) { attributes_for(:content) }
    let(:post_params) { attributes_for(:post, content_attributes: content_params) }

    it "creates a post" do
      expect {
        post :create, params: { board_id: board.id, post: post_params }
      }.to change(Post, :count).by(1)
    end

    it "redirects to all posts that is boards#show" do
      post :create, params: { board_id: board.id, post: post_params }
      expect(response).to redirect_to(board_path(board))
    end
  end

  describe "#show" do
    let(:post) { create :post, board: board }

    it "responds successfully" do
      get :show, params: { board_id: board.id, id: post.id }
      expect(response).to be_success
    end

    it "assigns @post with the post object" do
      get :show, params: { board_id: board.id, id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end
end
