class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      if @user.companies.empty? && request.env["omniauth.params"]["register_company"]
        sign_in @user
        redirect_to edit_user_registration_path
      else
        sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
        flash[:success] = "Hello, #{@user.first_name}. You're logged in!"
      end
    else
      session["devise.google_oauth2_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def intercom
    data = request.env["omniauth.auth"]
    params = request.env["omniauth.params"]

    token = data.credentials.token
    app_id = data.extra.raw_info.app.id_code

    company = Company.find_by_subdomain!(params["company_subdomain"])

    company.company_setting.intercom_workspace_id = app_id
    company.company_setting.intercom_access_token = token
    company.company_setting.save!

    flash[:success] = "You've successfully connected with Intercom"
    redirect_to admin_integrations_url(host: company.host)
  end

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  def failure
    super
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
