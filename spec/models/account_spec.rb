require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "Validations" do
    it { should belong_to :company }
  end
end
