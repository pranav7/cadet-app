class Users::RegistrationsController < Devise::RegistrationsController
  layout "public"

  before_action :ensure_app_subdomain, only: [:new]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  after_action :after_create_tasks, only: [:create]

  # GET /resource/sign_up
  def new
    @page_title = "Sign up - Cadet"
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
    def after_create_tasks
      if @user.persisted? && not(@user.companies.blank?)
        assign_admin_role
        send_welcome_email
      end
    end

    def assign_admin_role
      @user.make_admin!(@user.companies.first)
    end

    def send_welcome_email
      OnboardingMailer.welcome(@user).deliver_later(wait: 5.minutes)
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up,
                                        keys: [:first_name,
                                               :last_name,
                                               :job_title,
                                               memberships_attributes: [:primary, company_attributes: [:name, :subdomain]]])
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :job_title, memberships_attributes: [:role, company_attributes: [:name, :subdomain]]])
    end

    # The path used after sign up.
    def after_sign_up_path_for(resource)
      admin_boards_url(host: "#{current_user.companies.first.host}")
      # super(resource)
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

  private

  def ensure_app_subdomain
    unless request.subdomains.first == "app"
      redirect_to new_user_registration_url(subdomain: "app")
    end
  end
end
