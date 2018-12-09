require 'rails_helper'

RSpec.feature "the login process" do
  describe "customer login process", type: :feature do
    before :each do
      @company = create :company
      @board = create :board, company: @company

      @user = create :user, password: "password", password_confirmation: 'password'
    end

    xit "logs me in", js: true do
      visit_company @company, board_path(@board)
      click_link "Log in"
      perform_login

      expect(page).to have_content("Signed in successfully.")
    end

    xit "takes me back to the same page", js: true do
      post = create :post, board: @board, requester: @user

      visit_company @company, board_post_path(@board, post)

      find('a.vote-button').click
      within ".actions" do
        click_link "Log in"
      end
      perform_login

      expect(page).to have_content("Signed in successfully.")
      expect(page).to have_current_path(board_post_path(@board, post))
    end
  end

  def perform_login
    within("#login-form") do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: "password"
    end

    click_button "Log in"
  end
end
