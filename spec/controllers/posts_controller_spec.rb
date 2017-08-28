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
    it "creates a post" do
      content_params = attributes_for(:content)
      post_params = attributes_for(:post, content_attributes: content_params)

      expect {
        post :create, params: { post: post_params }
      }.to change(Post, :count).by(1)
    end
  end
end
