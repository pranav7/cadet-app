module SetCurrentCompany
  extend ActiveSupport::Concern

  included do
    helper_method :current_company
    def current_company
      begin
        @current_company ||= Company.find_by_subdomain!(request.subdomains.first)
      rescue
        not_found
      end
    end
  end
end
