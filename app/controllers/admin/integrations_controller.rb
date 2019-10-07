class Admin::IntegrationsController < Admin::AdminController
  before_action :set_menu_items

  def show
    @api_key = current_company.company_setting.api_key
  end

  private

  def set_menu_items
    @main_selected = :settings
    @sub_nav_selected = :integrations
  end
end
