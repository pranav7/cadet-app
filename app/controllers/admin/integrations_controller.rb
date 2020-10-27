class Admin::IntegrationsController < Admin::AdminController
  before_action :set_menu_items

  def show
    @api_key = current_company.company_setting.api_key
    @intercom_access_token = current_company.company_setting.intercom_access_token
  end

  private

  def set_menu_items
    @main_selected = :settings
    @sub_nav_selected = :integrations
  end
end
