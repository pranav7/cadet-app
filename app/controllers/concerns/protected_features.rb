module ProtectedFeatures
  extend ActiveSupport::Concern

  included do
    helper_method :can_access_feature?

    def can_access_feature?
      return true if Rails.env.development? || Rails.env.test?
      return false unless current_company.cadet_app?
      return false unless user_signed_in? && current_user.admin_of?(current_company)
      true
    end
  end
end
