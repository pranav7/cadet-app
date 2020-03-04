module ValidateCompanyExpiry
  extend ActiveSupport::Concern

  included do
    before_action :validate_company_expiry
  end

  private

  def validate_company_expiry
    return if ["app", "6cb33666"].include?(request.subdomains.first)

    redirect_to trial_expired_path if current_company.expired?
  end
end
