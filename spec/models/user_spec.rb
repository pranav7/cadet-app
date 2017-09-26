require 'rails_helper'

RSpec.describe User, type: :model do
  describe User, "Associations" do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:votes) }
    it { should have_many(:companies).through(:memberships) }
    it { should have_many(:memberships) }
    it { should have_many(:account_memberships) }
    it { should have_many(:accounts).through(:account_memberships) }
  end

  describe User, "Validations" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end

    it { should validate_presence_of(:first_name) }

    context "password validation" do
      it { should validate_presence_of(:password) }
      it { should validate_confirmation_of(:password) }
      it { should validate_length_of(:password).is_at_least(6) }
    end

    context "email validation" do
      subject { create :user }
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }

      context "format" do
        it "should not allow 'john' to be saved" do
          user = build :user, email: "john"
          expect(user.save).to be(false)
          expect(user.errors.full_messages).to include("Email is invalid")
        end

        it "should not allow 'john@' to be saved" do
          user = build :user, email: "john@"
          expect(user.save).to be(false)
          expect(user.errors.full_messages).to include("Email is invalid")
        end

        it "should not allow 'john@example. to be saved'" do
          user = build :user, email: "john@example"
          expect(user.save).to be(false)
          expect(user.errors.full_messages).to include("Email is invalid")
        end

        it "allows 'john@example.com to be saved'" do
          user = build :user, email: "john@example.com"
          expect(user.save).to be(true)
          expect(user.errors.full_messages).not_to include("Email is invalid")
        end
      end
    end
  end

  describe User, "#name" do
    it "returns a user's full name as a string" do
      user = build(:user, first_name: "Jon", last_name: "Snow")

      expect(user.name).to eq "Jon Snow"
    end
  end

  describe User, "#name=" do
    it "sets the user's first_name and last_name" do
      user = build(:user, name: "Jamie Lannister")

      expect(user.first_name).to eq("Jamie")
      expect(user.last_name).to eq("Lannister")
    end
  end

  describe "#initials" do
    it "returns the initials of the user's name" do
      user = build(:user, name: "Jamie Lannister")
      expect(user.initials).to eq("JL")
    end
  end
  
  describe User, "#voted?" do
    let(:vote) { create :vote }

    it "returns true if a user has voted the given post " do
      expect(vote.user.voted?(vote.post)).to eq(true)
    end

    it "returns false if a user has not voted the given post" do
      user = create :user
      expect(user.voted?(vote.post)).to eq(false)
    end
  end

  describe User, "#admin_of?" do
    let(:company) { create :company }
    let(:user) { create :admin, company: company }
    let(:another_company) { create :company }

    it "returns false if user is not admin" do
      customer = create :user, company: company
      expect(customer.admin_of?(company)).to eq(false)
    end

    it "returns true if user is admin of given company" do
      expect(user.admin_of?(company)).to eq(true)
    end

    it "returns false if user is not admin of given comapny" do
      expect(user.admin_of?(another_company)).to eq(false)
    end
  end

  describe User, "#customer_of?" do
    let(:company) { create :company }

    it "returns true if user is a customer of the given company" do
      customer = create :customer, company: company
      expect(customer.customer_of?(company)).to eq(true)
    end

    it "returns false if user not a customer of the given company" do
      customer = create :user
      expect(customer.customer_of?(company)).to eq(false)
    end

    it "returns false if user is an admin of the given company" do
      admin = create :admin, company: company
      expect(admin.customer_of?(company)).to eq(false)
    end
  end

  describe User, "#part_of" do
    let(:company) { create :company }
    let(:user) { create :admin, company: company }

    it "returns true if user is part of given company" do
      expect(user.part_of?(company)).to eq(true)
    end

    it "returns false if user is not part of given company" do
      other_company = create :company

      expect(user.part_of?(other_company)).to eq(false)
    end
  end
end
