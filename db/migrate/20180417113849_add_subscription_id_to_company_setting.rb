class AddSubscriptionIdToCompanySetting < ActiveRecord::Migration[5.2]
  def change
    add_column :company_settings, :paddle_subscription_id, :string
  end
end
