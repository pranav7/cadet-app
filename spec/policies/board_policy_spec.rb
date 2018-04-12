require 'rails_helper'

describe BoardPolicy do
  let(:company) { create :company }
  let(:admin) { create :admin, company: company }
  let(:board) { create :board, company: company, private: true }

  context "user has access" do
    it "returns true" do
      policy = BoardPolicy.new user: admin, resource: board
      expect(policy.accessible?).to eq(true)
    end
  end

  context "user does not have access" do
    let(:customer) { create :customer, company: company }

    it "returns false" do
      policy = BoardPolicy.new user: customer, resource: board
      expect(policy.accessible?).to eq(false)
    end
  end
end
