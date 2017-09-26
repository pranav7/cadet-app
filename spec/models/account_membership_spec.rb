require 'rails_helper'

RSpec.describe AccountMembership, type: :model do
  describe "Associations" do
    it { should belong_to :account }
    it { should belong_to :user }
  end

  describe "Validations" do
    it { should validate_presence_of :account }
    it { should validate_presence_of :user }
  end
end
