class Users::SessionsController < Devise::SessionsController
  layout "public"

  before_action :ensure_app_subdomain, only: [:new]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def ensure_app_subdomain
    unless request.subdomains.first == "app"
      redirect_to new_user_session_url(subdomain: "app")
    end
  end
end
