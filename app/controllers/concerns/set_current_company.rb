module SetCurrentCompany
  extend ActiveSupport::Concern

  included do
    helper_method :current_company
    def current_company
      begin
        @current_company ||= Company.find_by_subdomain!(request.subdomains.first)
      rescue StandardError
        not_found
      end
    end

    before_action do
      unless request.subdomains.first == "app"
        Current.company = current_company
      end
    end
  end
end
