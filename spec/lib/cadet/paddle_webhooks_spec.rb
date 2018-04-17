require 'rails_helper'

describe Cadet::PaddleWebhooks do
  describe "Subscription Created" do
    let(:company) { create :company }
    let(:passthrough) do
      { company_subdomain: company.subdomain }
    end

    let(:subscription_created_params) do
      {"alert_name"=>"subscription_created", "cancel_url"=>"https://checkout.paddle.com/subscription/cancel?user=1&subscription=3&hash=5d09438526268e6feb47189d428a437870b57f86", "checkout_id"=>"4-e263272da66c29d-775d2eb498", "currency"=>"USD", "email"=>"davis.natasha@example.net", "event_time"=>"2018-04-17 10:55:03", "marketing_consent"=>"marketing_consent", "next_bill_date"=>"2018-05-10", "passthrough"=>passthrough.to_json, "quantity"=>"72", "status"=>"active", "subscription_id"=>"4", "subscription_plan_id"=>"9", "unit_price"=>"unit_price", "update_url"=>"https://checkout.paddle.com/subscription/update?user=7&subscription=8&hash=d37156315b39c8c1e53edac0b4d8e6b64d2eadee", "p_signature"=>"ftawBfwda0sKs0VdPKfMpGmWee2w1ubHwwHRjfTupmuWnXdjth8MLKeNoIkAHkcEKD3R8BmDLhuKPrU/+FkNw9qoKOQtaJjXU6+M1ft9ccwfBnVC+or0hUYWXz/XCiu3lPwdkPkGhSUDgPMEkZEcZKGyJOuga6Z1AuWZwSoVeZE0F0bGhbKNnrZH/vT23qK+g4E0fKPC42BTRtjDKlht6sr2FjtVqWB6yQKmUgwCEQqZd2jSwE8JrSU38a3azOm8gGbRo7jBSu7jumqIzhyqG5uiaIzVwCdA2limFB8zCJTK0XM2edxYqII0knD9J961HoDIf1PyBbGTAMOECVSPyF5RStJ9x6tO+mHjw2Y0TOOIeWWKmNko+34HldkIclbs3KFz2eN3RYBdyipHGD9unL0cQb8kWGListWW7mGHQZG/IQMO5Ii8v5HJaeUGssYxKrsRxsZQSEszRUTTAI8aHNqmdUMb4P2gc+owRvA9yyKpVpre5jDx4IaOHVJ29/pL37M6U1mXvuKV/JvPBARtUlg0LQT8KmThmaA7HM+jUmdK/MESLLGA73TRZxKl0HuVgFd9agXNkwGUDrugfREo8rKq3kWcJX/5gLX+Mx3RNeQKk770lF2cIm0v86SivAaMugtVOEJ1eavlQfdkEKJVI6fo+/veMvZgI3VVeIUwAdM=", "controller"=>"admin/billing", "action"=>"consume_paddle_webhook"}
    end

    it "updates company to paying subscription" do
      expect(company.in_trial?).to eq(true)

      Cadet::PaddleWebhooks.new(subscription_created_params).consume

      company.reload
      expect(company.company_setting.paddle_subscription_id).to eq("4")
      expect(company.company_setting.billing_plan).to eq('basic')
      expect(company.company_setting.expires_at).to eq(nil)
    end
  end
end
