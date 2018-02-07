require 'rails_helper'

RSpec.feature "Signups", type: :feature do
  describe "customer signup process", js: true do
    before :each do
      @company = create :company
      @board = create :board, company: @company
    end

    it "signs me up" do
      visit_company @company, board_path(@board)

      click_link "Log in / Sign up"

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
