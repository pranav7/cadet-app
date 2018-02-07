class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    @user.transaction do
      @user.save
      Membership.create(user: @user, company: current_company)
    end

    if @user.errors.empty?
      sign_in @user
      flash[:success] = "Welcome, #{@user.name}!"

      if params[:user][:popup]
        redirect_back fallback_location: root_path
      else
        path = stored_location_for(@user) || root_path
        redirect_to path
      end
    else
      referring_path = URI(request.referrer).path
      session[:user_return_to] = referring_path unless referring_path == "/users"

      render action: :new
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:first_name,
              :last_name,
              :email,
              :password,
              :job_title)
  end
end
