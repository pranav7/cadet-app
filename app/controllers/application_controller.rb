class ApplicationController < ActionController::Base
  before_action :drop_naked_ip_requests
  protect_from_forgery preprend: true, with: :exception
  before_action :prepare_exception_notifier

  # before_action :ensure_valid_subdomain!

  helper_method :current_company

  def current_company
    @current_company ||= Company.find_by_subdomain(request.subdomains.first)
  end

  protected

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def ensure_valid_subdomain!
    return if request.subdomains.first == "app"
    if current_company.nil?
      not_found
      return
    end
    return unless user_signed_in?
    return if current_user.companies.map(&:subdomain).include?(request.subdomains.first)

    redirect_to root_url(host: "#{current_user.companies.first.subdomain}.#{APP_CONFIG['base_domain']}")
  end

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
