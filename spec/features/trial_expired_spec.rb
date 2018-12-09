require 'rails_helper'

RSpec.feature "the trial expired", type: :feature do
  let(:company) { create :company }
  let(:board) { create :board, company: company }

  describe "when trial expired", js: true do
    before :each do
      company.company_setting.expires_at = 1.day.ago
      company.company_setting.save
    end

    xit "redirects to the trial expired path" do
      visit_company company, board_path(board)
      expect(current_path).to eq("/trial_expired")
      expect(page).to have_content(/TRIAL EXPIRED/)
    end
  end

  describe "when trial not expired", js: true do
    before :each do
      company.company_setting.expires_at = nil
      company.company_setting.save
    end

    xit "takes to the board path like normal" do
      visit_company company, board_path(board)
      expect(current_path).to eq(board_path(board))
    end
  end
end
