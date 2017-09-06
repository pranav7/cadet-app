require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Associations" do
    it { should have_one(:content) }
    it { should have_many(:comments) }
    it { should belong_to(:user) }
    it { should belong_to(:company) }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }

    it "has a valid factory" do
      expect(build(:post)).to be_valid
    end
  end
end
