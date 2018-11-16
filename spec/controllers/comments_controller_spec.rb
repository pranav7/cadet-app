require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:board) { create :board }

  before :each do
    request.host = "#{board.company.subdomain}.example.com"
    sign_in user
  end

  describe "#create" do
    let(:_post) { create :post, board: board }
    let(:content_params) { attributes_for(:content) }
    let(:comment_params) { attributes_for(:comment, content_attributes: content_params) }

    describe "html" do
      let(:back) { "#{request.host}/posts/#{_post.id}" }
      before { request.env['HTTP_REFERER'] = back }

      it "redirects to back to where it came from" do
        post :create, params: { board_id: board.id, post_id: _post.id, comment: comment_params }
        expect(response).to redirect_to(back)
      end

      it "creates a comment" do
        expect {
          post :create, params: {
            board_id: board.id,
            post_id: _post.id,
            comment: comment_params
          }, format: :html
        }.to change(Comment, :count).by(1)
      end
    end

    describe "json" do
      it "creates a comment" do
        expect {
          post :create, params: {
            board_id: board.id,
            post_id: _post.id,
            comment: comment_params
          }, format: :json
        }.to change(Comment, :count).by(1)
      end
    end
  end
end
