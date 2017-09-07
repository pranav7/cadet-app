require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe Vote, "Association" do
    it { should belong_to :post }
    it { should belong_to :user }
  end
end
