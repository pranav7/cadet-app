require 'rails_helper'

describe UserPolicy do
  let(:company) { create :company }

  describe "#editable?" do
    it "returns true if current_company is primary company of resource" do
      customer = create :customer, company: company
      admin = create :admin, company: company

      expect(UserPolicy.new(current_company: company, current_user: admin, resource: customer).editable?).to eq(true)
    end
  end
end
