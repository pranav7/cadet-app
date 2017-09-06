require 'rails_helper'

RSpec.describe User, type: :model do
  describe User, "Associations" do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
    it { should have_many(:companies).through(:memberships) }
    it { should have_many(:memberships) }
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
      user = build(:user, first_name: "John", last_name: "Doe")

      expect(user.name).to eq "John Doe"
    end
  end
end
