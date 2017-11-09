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
end
