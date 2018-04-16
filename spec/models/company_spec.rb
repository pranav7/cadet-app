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
      company_setting = create :company_setting,
        company: company, expires_at: 1.day.ago

      expect(company.expired?).to eq(true)
    end

    it "returns false if trial not expired" do
      company_setting = create :company_setting,
        company: company, expires_at: 1.day.from_now

      expect(company.expired?).to eq(false)
    end

    it "returns false if no expiry is set" do
      company_setting = create :company_setting,
        company: company, expires_at: nil
      expect(company.expired?).to eq(false)
    end
  end
end
