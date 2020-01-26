require 'rails_helper'

RSpec.describe Content, type: :model do
  it { is_expected.to belong_to(:parent).optional(true) }

  describe "Validations" do
    it { is_expected.to validate_presence_of(:body) }

    it "has a valid factory" do
      expect(build(:content_for_post)).to be_valid
    end
  end
end
