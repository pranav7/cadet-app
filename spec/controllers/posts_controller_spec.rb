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

    it "assings @post with a new object" do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe "#create" do
    it "creates a post" do
      content_params = attributes_for(:content)
      post_params = attributes_for(:post, content_attributes: content_params)

      expect {
        post :create, params: { post: post_params }
      }.to change(Post, :count).by(1)
    end
  end

  describe "#index" do
    it "responds successfully" do
      get :index
      expect(response).to be_success
    end

    it "populates @posts with all posts" do
      posts = create_list :post, 3
      get :index
      expect(assigns(:posts)).to eq(posts)
    end
  end
end
