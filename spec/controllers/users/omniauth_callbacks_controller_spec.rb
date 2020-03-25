require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  let(:intercom_workspace_id) { "abc123" }
  let(:auth_token) { "auth_token" }
  let(:company) { create :company }
  let!(:company_setting) { create :company_setting, company: company, intercom_workspace_id: intercom_workspace_id }
  let(:user) { create :user, company: company }

  before do
    request.host = "app.lvh.me:3000"
    stub_env_for_omniauth
  end

  context "on success" do
    it "saves access token successfully" do
      get :intercom
      expect(company.company_setting.reload.intercom_access_token)
        .to eq(auth_token)
    end

    it "redirects to integrations page" do
      get :intercom
      expect(response).to redirect_to(admin_integrations_url(host: company.host))
    end
  end

  def stub_env_for_omniauth # rubocop:disable Metrics/MethodLength
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
      provider: 'intercom',
      uid: '342324',
      info: {
        email: 'john.dev@intercom.io',
        name: 'John Dev'
      },
      credentials: {
        token: auth_token,
        expires: false
      },
      extra: {
        raw_info: {
          email: 'john.dev@intercom.io',
          name: 'John Dev',
          type: 'admin',
          id: '342324',
          email_verified: true,
          app: {
            id_code: intercom_workspace_id,
            type: 'app',
            secure: true,
            timezone: "Dublin",
            name: "Cadet-Test"
          },
          avatar: {
            image_url: "https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491"
          }
        }
      }
    )
    request.env["omniauth.params"] = {"company_subdomain"=> company.subdomain}
  end
end
