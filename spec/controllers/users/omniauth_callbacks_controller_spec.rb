require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user, company: company }

  before do
    request.host = "#{company.subdomain}.example.com"
    sign_in user
  end

  describe "Triggers intercom callback" do
    it "saves access token successfully" do
      mock_omniauth_intercom
      get user_intercom_omniauth_authorize_path

      expect(company.company_setting.intercom_access_token)
        .to eq("dG9rOmNdrWt0ZjtgzzE0MDdfNGM5YVe4MzsmXzFmOGd2MDhiMfJmYTrxOtA=")
    end

  end
end
