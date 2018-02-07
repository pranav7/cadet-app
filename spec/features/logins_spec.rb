require 'rails_helper'

RSpec.feature "the login process", type: :feature do
  describe "customer login process" do
    before :each do
      @company = create :company
      @board = create :board, company: @company

      @user = create :user, password: "password", password_confirmation: 'password'
    end

    it "signs me in" do
      visit_company @company, board_path(@board)

      click_link "Log in / Sign up"
      login

      expect(page).to have_content("Signed in successfully.")
    end

    it "takes me back to the same page" do
      post = create :post, board: @board, requester: @user

      visit_company @company, board_post_path(@board, post)

      find('a.vote-button').click
      login

      expect(page).to have_content("Signed in successfully.")
      expect(page).to have_current_path(board_post_path(@board, post))
    end
  end

  def login
    click_link "Log in"

    within("#login-form") do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: "password"
    end

    click_button "Log in"
  end 

  def visit_company(company, path = "/")
    app_host = URI.join("http://#{company.subdomain}.lvh.me").to_s
    using_app_host(app_host) do
      visit path
    end
  end

  def using_app_host(host)
    original_host = Capybara.app_host
    Capybara.app_host = host
    yield
  ensure
    Capybara.app_host = original_host
  end
end
