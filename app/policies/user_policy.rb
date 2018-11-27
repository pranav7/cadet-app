class UserPolicy
  attr_reader :current_company, :resource, :current_user

  def initialize(current_company:, current_user:, resource:)
    @current_company = current_company
    @current_user= current_user
    @resource = resource
  end

  def editable?
    editable_by_current_company? &&
      current_user.admin_of?(current_company)
  end

  private
  def editable_by_current_company?
    resource.primary_company == current_company
  end
end
