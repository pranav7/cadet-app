require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe Membership, "Associations" do
    it { should belong_to :company }
    it { should belong_to :user }
  end

  describe Membership, "Validations" do
    it { should validate_presence_of :company }
    it { should validate_presence_of :user }
  end
end
