module SetCurrentCompany
  extend ActiveSupport::Concern

  included do
    helper_method :current_company

    def current_company
      @current_company ||= Company.find_by_subdomain!(request.subdomains.first)
    rescue StandardError
      not_found
    end

    before_action do
      Current.company = current_company unless ["app", "6cb33666"].include?(request.subdomains.first)
    end
  end
end
