class ApplicationController < ActionController::Base
  before_action :drop_naked_ip_requests
  protect_from_forgery preprend: true, with: :exception
  before_action :prepare_exception_notifier
  before_action :validate_company_expiration

  helper_method :current_company
  def current_company
    begin
      @current_company ||= Company.find_by_subdomain!(request.subdomains.first)
    rescue
      not_found
    end
  end

  def validate_company_expiration
    return if request.subdomains.first == "app"

    if current_company.expired?
      redirect_to trial_expired_path
    end
  end

  protected
    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    def authorize_admin_access!
      authenticate_user!
      not_found unless current_user.admin_of?(current_company)
    end

  private
    def after_sign_in_path_for(resource)
      return request.env['omniauth.origin'] if request.env['omniauth.origin']

      if stored_location = stored_location_for(resource)
        subdomain = session[:subdomain] || current_user.companies.first.subdomain
        return "http://#{subdomain}.#{APP_CONFIG["base_domain"]}#{stored_location}"
      end

      admin_boards_url(host: "#{current_user.companies.first.host}")
    end

    def after_sign_out_path_for(resource_or_scope)
      request.referrer || stored_location_for(resource_or_scope) || super
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

      if request.url == "https://18.218.51.86/"
        head :not_found
      end
    end
end
