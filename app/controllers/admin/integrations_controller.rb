class Admin::IntegrationsController < Admin::AdminController
  before_action :set_menu_items

  def show
    @api_key = current_company.company_setting.api_key
    @intercom_access_token = current_company.company_setting.intercom_access_token
    @company_setting = current_company.company_setting
    @canvas_label = 'Share Feedback'
    @canvas_text = 'Share ideas or feedback'
    @canvas_label = @company_setting.intercom_canvas_settings['canvas_label'] if @company_setting.intercom_canvas_settings && !@company_setting.intercom_canvas_settings['canvas_label'].blank?
    @canvas_text = @company_setting.intercom_canvas_settings['canvas_text'] if @company_setting.intercom_canvas_settings && !@company_setting.intercom_canvas_settings['canvas_text'].blank?
  end

  def update
    @company_setting = current_company.company_setting
    @company_setting.intercom_canvas_settings['canvas_label'] = params[:company_setting]['canvas_label']
    @company_setting.intercom_canvas_settings['canvas_text'] = params[:company_setting]['canvas_text']
    redirect_to admin_integrations_path if @company_setting.save
  end

  private

  def set_menu_items
    @main_selected = :settings
    @sub_nav_selected = :integrations
  end
end
