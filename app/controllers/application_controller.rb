class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_raven_context
  before_action :prepare_exception_notifier
  before_action :drop_naked_ip_requests

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

  def set_raven_context
    if user_signed_in?
      context = {
        id: current_user.id,
        email: current_user.email,
      }

      if current_company
        context[:company] = current_company.subdomain
      end

      Raven.user_context(context)
    end

    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
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
    if request.url == "https://18.221.127.87/"
      head :not_found
    end
  end
end
