class BoardPolicy
  def initialize(user:, resource:)
    @user = user
    @resource = resource
  end

  def accessible?
    if @resource.private? and !@user.admin_of?(@resource.company)
      false
    else
      true
    end
  end
end
