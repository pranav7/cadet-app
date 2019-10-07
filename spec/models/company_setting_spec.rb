require 'rails_helper'

RSpec.describe CompanySetting, type: :model do
  describe "Associations" do
    it { should belong_to(:company) }
  end

  describe "Validations" do
    it { should validate_uniqueness_of(:intercom_workspace_id) }
  end

  describe "before create" do
    let(:company) { create :company }
    let!(:company_setting) { create :company_setting, company: company }

    it "generates and stores api token" do
      expect(company_setting.api_key).to_not be_nil
    end
  end
end
