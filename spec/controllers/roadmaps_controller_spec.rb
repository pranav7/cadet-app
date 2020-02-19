require 'rails_helper'

RSpec.describe RoadmapsController, type: :controller do
  render_views
  let(:company1) { create :company }
  let(:company2) { create :company }
  let(:user) { create :user, company: company1 }
  let!(:membership) { create :membership, company: company1, user: user, owner: true, primary: true, role: :admin }

  let(:board) { create :board, company: company1 }
  let(:board2) { create :board, company: company2 }
  let(:roadmap_disabled_board) { create :board, company: company1, roadmap_enabled: false }
  let!(:post1) { create :post, board: board, status: 1 }
  let!(:post2) { create :post, board: roadmap_disabled_board, status: 1 }
  let(:private_board) { create :board, company: company1, private: true }
  let!(:post3) { create :post, board: private_board, status: 1 }
  let!(:post4) { create :post, board: board2, status: 1 }

  before :each do
    request.host = "#{company1.subdomain}.example.com"
  end

  describe "GET index" do

    it "Index only planned posts belonging roadmap enabled boards" do
      sign_in user

      get :index
      expect(assigns(:planned_posts)).to eq([post3, post1])
    end

    it "Index posts only from public boards" do
      get :index
      expect(assigns(:planned_posts)).to eq([post1])
    end

    it "Index planned posts ordered by latest activity" do
      sign_in user

      get :index
      expect(assigns(:planned_posts)).to eq([post3, post1])
    end

    it "should return empty list for devloping status in roadmap" do
      get :index

      expect(assigns(:devloping_posts)).to eq([])
    end

    it "should return empty list for released status in roadmap" do
      get :index

      expect(assigns(:released_posts)).to eq([])
    end
  end
end
