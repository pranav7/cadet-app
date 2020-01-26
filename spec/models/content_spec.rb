require 'rails_helper'

RSpec.describe Content, type: :model do
  it { should belong_to(:parent) }

  describe "Validations" do
    it { should validate_presence_of(:body) }

    it "has a valid factory" do
      expect(build(:content_for_post)).to be_valid
    end
  end
end
