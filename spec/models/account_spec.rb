require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "Validations" do
    it { should belong_to(:company) }
    it { should have_many(:account_memberships) }
    it { should have_many(:users).through(:account_memberships) }
  end
end
