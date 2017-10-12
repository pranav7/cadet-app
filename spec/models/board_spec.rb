require 'rails_helper'

RSpec.describe Board, type: :model do
  describe Board, "Associations" do
    it { should belong_to(:company) }
    it { should have_many(:posts) }
  end

  describe "Validations" do
    # it { should validate_uniqueness_of(:name).scoped_to(:company).case_insensitive }
  end
end
