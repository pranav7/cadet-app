class ApplicationController < ActionController::Base
  before_action :drop_naked_ip_requests
  protect_from_forgery preprend: true, with: :exception
  before_action :prepare_exception_notifier

  helper_method :current_company

  def current_company
    begin
      @current_company ||= Company.find_by_subdomain!(request.subdomains.first)
    rescue
      not_found
    end
  end

  protected

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def authorize_board_access!
    authenticate_user!
    not_found unless current_user.admin_of?(current_company)
  end

  private

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || admin_boards_url(host: "#{current_user.companies.first.subdomain}.#{APP_CONFIG['base_domain']}")
  end

  def prepare_exception_notifier
    exception_data = {
      url: request.url,
      ip: request.ip
    }
    exception_data[:current_user] = current_user.serializable_hash if user_signed_in?

    request.env["exception_notifier.exception_data"] = exception_data
  end

  def drop_naked_ip_requests
    Rails.logger.info "Request IP: #{request.ip}"
    Rails.logger.info "Request URL: #{request.method} #{request.url}"

    if request.url == "https://18.221.127.87/"
      head :not_found
    end
  end
end
