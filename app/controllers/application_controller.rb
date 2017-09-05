class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_company

  def current_company
    @current_company = Company.find_by_subdomain(request.subdomains.first)
  end

  private

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_url(host: "#{current_user.companies.first.subdomain}.lvh.me:3000")
  end
end
