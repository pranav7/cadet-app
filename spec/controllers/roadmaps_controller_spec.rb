require 'rails_helper'

RSpec.describe RoadmapsController, type: :controller do
  render_views
  let(:company) { create :company }
  let(:user) { create :user, company: company }
  let(:board) { create :board, company: company }
  let(:post) { create :post, board: board, user: user, status: :planned }

  before :each do
    sign_in user
    request.host = "#{company.subdomain}.example.com"
  end

  describe "GET index" do
    it "lists the post in the roadmap's planned posts group" do
        get :index

        assigns(:planned_posts).should eq([post])
      end
  end
  
end
