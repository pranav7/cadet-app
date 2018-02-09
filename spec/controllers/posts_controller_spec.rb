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

  describe '#new' do
    it "responds successfully" do
      get :new, params: { board_id: board.id }
      expect(response).to be_success
    end
  end

  describe "#show" do
    context "public board" do
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

    context "private board" do
      let(:private_board) { create :board, company: company, private: true }
      let(:post) { create :post, board: private_board }

      it "responds with 404 if board is private and current_user is not admin" do
        expect {
          get :show, params: { board_id: private_board.id, id: post.id }
        }.to raise_error(ActionController::RoutingError)
      end

      it "responds with success if board is private but current_user is admin" do
        admin = create :admin, company: company
        sign_in admin

        get :show, params: { board_id: private_board.id, id: post.id }

        expect(response).to be_success
      end
    end
  end
end
