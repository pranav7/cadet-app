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
    begin
      validate_role
      validate_membership

      self.resource = find_or_invite_resource do |user|
        membership = user.memberships.build(company: current_company, role: params[:role].downcase)
        user.skip_invitation = true if params[:send_invitation] != "true"
      end

      resource_invited = resource.errors.empty?

      yield resource if block_given?

      if resource_invited
        if is_flashing_format? && self.resource.invitation_sent_at
          set_flash_message :notice, :send_instructions, email: self.resource.email
        end

        respond_with resource, location: admin_users_path
      else
        respond_with_navigational(resource) { redirect_to admin_users_path }
      end
    rescue => e
      flash[:error] = e.message
      redirect_to admin_users_path
    end
  end

  def edit
    super
  end

  def update
    if params[:invite_again]
      user = User.find(params[:format])
      user.invite!(current_user)

      flash[:success] = "Invitation Sent!"
      return redirect_to admin_user_path(user)
    end

    super
  end
  
  protected

  def find_or_invite_resource(&block)
    if user = User.find_by_email(invite_params[:email])
      flash[:sucess] = "We've added #{user.name} to your company"
      user.memberships.create(company: current_company, role: params[:role].downcase)
      user
    else
      resource_class.invite!(invite_params, current_inviter, &block)
    end
  end

  private

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
    raise "The role provided is invalid"
  end

  def validate_membership
    user = User.find_by_email(invite_params[:email])
    return unless user

    membership = current_company.memberships.where(user: user).first 
    if membership
      raise "Oops! A user with this email already exists."
    end
  end
end
