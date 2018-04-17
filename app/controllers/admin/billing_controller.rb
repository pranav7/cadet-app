class Admin::BillingController < Admin::AdminController
  before_action :set_menu_items

  skip_before_action :verify_authenticity_token, only: [:consume_paddle_webhook]
  skip_before_action :authenticate_user!, only: [:consume_paddle_webhook]
  skip_before_action :authorize!, only: [:consume_paddle_webhook]
  skip_before_action :validate_company_expiry, only: [:consume_paddle_webhook]

  def show
  end

  def consume_paddle_webhook
    Cadet::PaddleWebhooks.new(params).consume
    render text: "OK", status: :ok
  end

  private
    def set_menu_items
      @main_selected = :settings
      @sub_nav_selected = :billing
    end
end
