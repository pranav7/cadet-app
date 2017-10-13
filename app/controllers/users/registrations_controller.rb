class Users::RegistrationsController < Devise::RegistrationsController
  layout "public"

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  after_action :assign_admin_role, only: [:create]
  after_action :notify_slack, only: [:create]

  # GET /resource/sign_up
  def new
    build_resource({})
    self.resource.memberships.build.build_company
    respond_with self.resource
  end

  # POST /resource
  # def create
  #  super
  # end

  # GET /resource/edit
  def edit
    self.resource.memberships.build.build_company
    super
  end

  # PUT /resource
  def update
    if current_user.update_attributes(account_update_params)
      flash[:success] = "Welcome to Cadet!"
      sign_in_and_redirect current_user
    else
      flash[:error] = "Something went wrong!"
      render action: :edit
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def assign_admin_role
    if @user.persisted? && not(@user.companies.blank?)
      @user.make_admin!(@user.companies.first)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [:first_name,
                                             :last_name
                                             :job_title,
                                             memberships_attributes: [ company_attributes: [:name, :subdomain]]])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :job_title, memberships_attributes: [:role, company_attributes: [:name, :subdomain]]])
  end

  def notify_slack  
    message = "*#{@user.name} (#{@user.email}) signed up!*"
    if @user.job_title
      message << "\n"
      message << "_#{@user.job_title}_"
    end
    message << "\n"
    message << "#{@user.companies.first.name} - http://#{@user.companies.first.subdomain}.getcadet.com/"

    client = Slack::Web::Client.new
    client.chat_postMessage(channel: '#main', text: message, as_user: true)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
