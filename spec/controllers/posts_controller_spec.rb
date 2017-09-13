require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:board) { create :board, company: company }

  before :each do
    request.host = "#{user.companies.first.subdomain}.example.com"
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

    it "redirects to all posts" do
      post :create, params: { board_id: board.id, post: post_params }
      expect(response).to redirect_to(board_posts_path(board))
    end
  end

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "assigns @posts with all posts" do
      posts = create_list :post, 3, company: company
      get :index
      expect(assigns(:posts)).to eq(posts.reverse)
    end

    it "does not assign @posts with other company's posts" do
      posts = create_list :post, 3
      get :index
      expect(assigns(:posts)).to eq([])
    end

    it "assings @post with a new object" do
      get :index
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "#show" do
    let(:post) { create :post, company: company }

    it "responds successfully" do
      get :show, params: { id: post.id }
      expect(response).to be_success
    end

    it "assigns @post with the post object" do
      get :show, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end
end
