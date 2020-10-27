class Users::SessionsController < Devise::SessionsController
  layout "public"

  before_action :ensure_app_subdomain, only: [:new]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @page_title = "Login - Cadet"
    super
  end

  # POST /resource/sign_in
  def create
    if params[:user][:popup] && params[:user][:popup] == "true"
      session[:user_return_to] = URI(request.referer).path
      session[:subdomain] = current_company.subdomain
    end

    super
  end

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
    redirect_to new_user_session_url(subdomain: request.subdomain) unless ["app", "cadet-app"].include?(request.subdomain)
  end
end
