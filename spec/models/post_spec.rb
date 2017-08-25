require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "Associations" do
    it { should have_one(:content) }
  end
end
