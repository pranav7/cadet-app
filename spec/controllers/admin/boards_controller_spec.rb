require 'rails_helper'

describe Admin::BoardsController, type: :controller do
  let(:company) { create :company }
  let(:admin) { create :admin, company: company }

  before :each do
    request.host = "#{company.subdomain}.example.com"
    sign_in admin
  end

  describe "#new" do
    it "responds successfully" do
      get :new
      expect(response).to be_success
    end
  end

  describe "#create" do
    let(:board_params) { attributes_for(:board) }

    it "creates a board" do
      expect {
        post :create, params: { board: board_params }
      }.to change(Board, :count).by(1)
    end

    it "redirects to boards path" do
      post :create, params: { board: board_params }
      expect(response).to redirect_to(admin_boards_path)
    end
  end
end
