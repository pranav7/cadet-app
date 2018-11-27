require 'rails_helper'

RSpec.describe Board, type: :model do
  describe Board, "Associations" do
    it { should belong_to(:company) }
    it { should have_many(:posts) }
  end

  describe "Validations" do
    # it { should validate_uniqueness_of(:name).scoped_to(:company).case_insensitive }
  end

  describe "::non_public" do
    it "returns only private boards" do
      private_board = create :board, private: true
      public_board = create :board

      expect(Board.non_public).to eq([private_board])
    end
  end

  describe "::non_private" do
    it "returns only public boards" do
      private_board = create :board, private: true
      public_board = create :board

      expect(Board.non_private).to eq([public_board])
    end
  end
end
