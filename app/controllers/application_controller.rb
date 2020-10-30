class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :drop_naked_ip_requests

  include SetCurrentRequestDetails
  include SetCurrentCompany
  include ValidateCompanyExpiry
  include PrepareExceptionNotifier
  include AuthorizeAdminAccess
  include Rails::Pagination
  include IntercomIframe
  include ProtectedFeatures

  rescue_from Errors::AdminLacksPermission, with: :handle_missing_permissions
  rescue_from Errors::ServiceValidationException, with: :handle_validation_error

  protected

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def handle_missing_permissions(error)
    respond_to do |format|
      format.html do
        flash[:error] = error.message || "User does not have permission"
        redirect_back fallback_location: root_path
      end

      format.json { render status: :forbidden, json: { message: 'permissions_error' } }
    end
  end

  def handle_validation_error(error)
    respond_to do |format|
      format.html do
        flash[:error] = error.message
        redirect_back fallback_location: root_path
      end

      format.json { render status: :unprocessable_entity, json: { message: error.message } }
    end
  end

  private

  def after_sign_in_path_for(resource)
    return request.env['omniauth.origin'] if request.env['omniauth.origin']

    stored_location = stored_location_for(resource)
    if stored_location
      subdomain = session[:subdomain] || current_user.companies.first.subdomain

      return "http://#{subdomain}.#{APP_CONFIG['base_domain']}#{stored_location}"
    end

    admin_boards_url(host: current_user.companies.first.host.to_s)
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer || stored_location_for(resource_or_scope) || super
  end

  def drop_naked_ip_requests
    Rails.logger.info "Request IP: #{request.ip}"
    Rails.logger.info "Request URL: #{request.method} #{request.url}"

    head :not_found if request.url == "https://18.218.51.86/"
  end
end
