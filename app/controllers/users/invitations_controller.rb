class Users::InvitationsController < Devise::InvitationsController
  layout "public"

  before_action :configure_invite_params, only: [:create]
  before_action :configure_accept_invitation_params, only: [:edit, :update]
  before_action -> { current_user.admin_of?(current_company) }, only: [:new, :create]

  def new
    super
  end

  # POST /resource/invitation
  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  private

  def invite_resource
    super do |user|
      validate_role
      user.memberships.build(company: current_company, role: params[:role].downcase)
    end
  end

  def after_invite_path_for(current_inviter)
    admin_users_path
  end

  def configure_invite_params
    devise_parameter_sanitizer
      .permit(:invite, keys: [:first_name, :last_name, :email])
  end

  def configure_accept_invitation_params
    devise_parameter_sanitizer
      .permit(:accept_invitation, keys: [:job_title])
  end

  def validate_role
    return if Membership.roles.keys.include?(params[:role].downcase)
    raise BadRequest.new("The role provided is invalid")
  end
end
