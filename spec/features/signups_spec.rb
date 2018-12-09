require 'rails_helper'

RSpec.feature "Signups" do
  describe "customer signup process", type: :feature do
    before :each do
      @company = create :company
      @board = create :board, company: @company
    end

    it "signs me up", :js do
      visit_company @company, board_path(@board)

      within ".public-header" do
        click_link "Sign up"
      end

      within("#new_user") do
        fill_in 'First Name', with: "John"
        fill_in 'Last Name', with: "Doe"
        fill_in 'Email', with: 'john@doe.com'
        fill_in 'Password', with: "password"
      end

      click_button "Sign up"
      expect(page).to have_content("Welcome, John Doe!")
    end
  end
end
