require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Associations" do
    it { should have_one(:content) }
    it { should belong_to(:user) }
    it { should have_many(:comments) }
  end
end
