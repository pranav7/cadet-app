require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "#new" do
    it "responds successfully" do
      get :new
      expect(response).to be_success
    end

    it "returns a 200 response" do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe "#create" do
    let(:content_params) { attributes_for(:content) }
    let(:post_params) { attributes_for(:post, content_attributes: content_params) }

    it "creates a post" do
      expect {
        post :create, params: { post: post_params }
      }.to change(Post, :count).by(1)
    end

    it "redirects to all posts" do
      post :create, params: { post: post_params }
      expect(response).to redirect_to(posts_path)
    end
  end

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "assigns @posts with all posts" do
      posts = create_list :post, 3
      get :index
      expect(assigns(:posts)).to eq(posts)
    end

    it "assings @post with a new object" do
      get :index
      expect(assigns(:post)).to be_a_new(Post)
    end
  end
end
