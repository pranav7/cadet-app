require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }

  before :each do
    request.host = "#{user.companies.first.subdomain}.example.com"
    sign_in user
  end

  describe "#create" do
    let(:_post) { create :post, company: user.companies.first }
    let(:content_params) { attributes_for(:content) }
    let(:comment_params) { attributes_for(:comment, content_attributes: content_params) }

    let(:back) { "#{request.host}/posts/#{_post.id}" }
    before { request.env['HTTP_REFERER'] = back }

    it "redirects to back to where it came from" do
      post :create, params: { post_id: _post.id, comment: comment_params }
      binding.pry
      expect(response).to redirect_to(back)
    end

    it "creates a comment" do
      expect {
        post :create, params: { post_id: _post.id, comment: comment_params }
      }.to change(Comment, :count).by(1)
    end
  end
end
