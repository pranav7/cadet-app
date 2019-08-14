module SetCurrentCompany
  extend ActiveSupport::Concern

  included do
    helper_method :current_company

    def current_company
      @current_company ||= Company.find_by_subdomain!(request.subdomains.first)
    rescue StandardError
      Company.first
      # not_found
    end

    before_action do
      unless ["app"].include?(request.subdomains.first)
        Current.company = current_company
      end
    end
  end
end
