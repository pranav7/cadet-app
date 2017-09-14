require 'rails_helper'

RSpec.describe Board, type: :model do
  describe Board, "Associations" do
    it { should belong_to(:company) }
    it { should have_many(:posts) }
  end
end
