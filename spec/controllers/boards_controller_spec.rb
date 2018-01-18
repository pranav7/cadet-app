require 'rails_helper'

RSpec.describe BoardsController, type: :controller do
  let(:company) { create :company }
  let!(:board) { create :board, company: company }

  before :each do
    request.host = "#{company.subdomain}.example.com"
  end

  describe "GET index" do
    context "only one board" do
      it "redirects to board#show" do
        get :index
        expect(response).to redirect_to(board_path(board))
      end
    end

    context "multiple boards" do
      it "lists them on the page" do
        board2 = create :board, company: company

        get :index

        expect(response).to be_success
        expect(response).to_not redirect_to(board_path(board2))
      end
    end
  end

  describe "GET show" do
    let(:admin) { create :admin, company: company }
    let(:customer) { create :customer, company: company }
    let(:private_board) { create :board, company: company, private: true }

    context "private board" do
      it "redirects to 404 page if user is not admin" do
        sign_in customer

        expect {
          get :show, params: { id: private_board.id }
        }.to raise_error(ActionController::RoutingError)
      end

      it "returns success if user is admin" do
        sign_in admin

        get :show, params: { id: private_board.id }

        expect(response).to be_success
      end
    end

    context "public board" do
      it "returns success response" do
        get :show, params: { id: board.id }
        expect(response).to be_success
      end
    end
  end
end
