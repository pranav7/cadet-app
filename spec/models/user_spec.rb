require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Associations" do
    it { should belong_to(:company) }
    it { should have_many(:posts) }
    it { should have_many(:comments) }
  end
end
