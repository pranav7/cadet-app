module AuthorizeAdminAccess
  extend ActiveSupport::Concern

  protected
  def authorize_admin_access!
    authenticate_user!
    not_found unless current_user.admin_of?(current_company)
  end
end
