module ValidateCompanyExpiry
  extend ActiveSupport::Concern

  included do
    before_action :validate_company_expiry
  end

  private
    def validate_company_expiry
      return if request.subdomains.first == "app"

      if current_company.expired?
        redirect_to trial_expired_path
      end
    end
end
