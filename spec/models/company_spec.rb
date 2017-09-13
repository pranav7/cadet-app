require 'rails_helper'

RSpec.describe Company, type: :model do
  describe "Associations" do
    it { should have_many(:memberships) }
    it { should have_many(:users).through(:memberships) }
    it { should have_many(:posts) }
    it { should have_many(:boards) }
  end

  describe "Validations" do
    it { should validate_presence_of(:subdomain) }
    it { should validate_uniqueness_of(:subdomain) }

    it { should validate_presence_of(:name) }

    it "has a valid factory" do
      expect(build(:company)).to be_valid
    end
  end
end
