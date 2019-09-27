require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "Associations" do
    it { should have_many(:memberships) }
    it { should have_many(:users).through(:memberships) }
    it { should have_many(:boards) }
    it { should have_many(:accounts) }
    it { should have_one(:company_setting) }
  end

  describe "Validations" do
    subject { create :company }
    it { should validate_presence_of(:subdomain) }
    it { should validate_uniqueness_of(:subdomain) }
    it { should validate_uniqueness_of(:intercom_workspace_id) }

    it { should validate_presence_of(:name) }

    it "has a valid factory" do
      expect(build(:company)).to be_valid
    end
  end

  describe "#customers" do
    let(:company) { create :company }

    it "returns customers of the company" do
      customers = create_list :customer, 3, company: company
      expect(company.customers).to eq(customers)
    end

    it "should not return admins" do
      create_list :admin, 3, company: company
      expect(company.customers).to eq([])
    end
  end

  describe "#admins" do
    let(:company) { create :company }

    it "returns admins of the company" do
      admin = create :admin, company: company
      expect(company.admins).to eq([admin])
    end

    it "should not return customers of the company" do
      create_list :customer, 3, company: company
      admin = create :admin, company: company
      expect(company.admins).to eq([admin])
    end
  end

  describe "#expired?" do
    let(:company) { create :company }

    it "returns true if trial expired" do
      create :company_setting, company: company, expires_at: 1.day.ago

      expect(company.expired?).to eq(true)
    end

    it "returns false if trial not expired" do
      create :company_setting, company: company, expires_at: 1.day.from_now

      expect(company.expired?).to eq(false)
    end

    it "returns false if no expiry is set" do
      create :company_setting, company: company, expires_at: nil

      expect(company.expired?).to eq(false)
    end
  end

  describe "#active_users" do
    let(:company) { create :company }
    let(:board) { create :board, company: company }

    it "returns all active users" do
      user_a = create :customer, company: company
      user_b = create :customer, company: company
      user_c = create :customer, company: company
      create :customer, company: company

      post = create :post, board: board, requester: user_a
      create :vote, post: post, user: user_b
      create :comment, post: post, commenter: user_c

      expect(company.active_users.count).to eq(3)
      expect(company.users.count).to eq(4)
    end
  end

  describe "#owner" do
    let(:company) { create :company }
    let!(:membership) { create :membership, company: company, user: user, owner: true }
    let(:user) { create :user }

    it "returns the owner of the company" do
      expect(company.owner).to eq(user)
    end
  end

  describe "#create_sample_board_and_post" do
    let(:company) { create :company }
    let!(:membership) { create :membership, company: company, owner: true }

    it "creates sample board" do
      company.create_sample_board_and_post

      expect(company.boards.count).to eq(1)
      expect(company.boards.first.title).to eq("Feature Requests")
      expect(company.boards.first.description).to eq("Let us know your feedback or feature requests")
    end

    it "creates sample post in sample board" do
      company.create_sample_board_and_post
      board = company.boards.first

      expect(board.posts.count).to eq(1)
      expect(board.posts.first.title).to eq("Getting started")
    end
  end
end
