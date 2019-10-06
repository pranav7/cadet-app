require 'rails_helper'

RSpec.describe CompanySetting, type: :model do
  describe "Associations" do
    it { should belong_to(:company) }
  end

  describe "Validations" do
    it { should validate_uniqueness_of(:intercom_workspace_id) }
  end
end
