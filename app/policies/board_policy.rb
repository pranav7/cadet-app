class BoardPolicy
  def initialize(user:, resource:)
    @user = user
    @resource = resource
  end

  def accessible?
    if @resource.private? and not(@user.admin_of?(@resource.company))
      return false
    else
      return true
    end
  end
end
