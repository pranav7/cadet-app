require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user, company: company }

  describe "Triggers intercom callback" do
    it "saves access token successfully" do
      mock_omniauth_intercom
      get :intercom

      expect(company.company_setting.intercom_access_token)
        .to eq("dG9rOmNdrWt0ZjtgzzE0MDdfNGM5YVe4MzsmXzFmOGd2MDhiMfJmYTrxOtA=")
    end
  end
end

def mock_omniauth_intercom
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:intercom] = OmniAuth::AuthHash.new(
    provider: 'intercom',
    uid: '342324',
    :info => {
      :email => 'john.dev@intercom.io',
      :name => 'John Dev'
    },
    :credentials => {
      :token => 'dG9rOmNdrWt0ZjtgzzE0MDdfNGM5YVe4MzsmXzFmOGd2MDhiMfJmYTrxOtA=',
      :expires => false
    },
    :extra => {
      :raw_info => {
        :email => 'john.dev@intercom.io',
        :name => 'John Dev',
        :type => 'admin',
        :id => '342324',
        :email_verified => true,
        :app => {
          :id_code => 'abc123',
          :type => 'app',
          :secure => true,
          :timezone => "Dublin",
          :name => "Cadet-Test"
        },
        :avatar => {
          :image_url => "https://static.intercomassets.com/avatars/343616/square_128/me.jpg?1454165491"
        }
      }
    })
  end
