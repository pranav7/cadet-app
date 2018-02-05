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
      redirect_back fallback_location: root_path
    else
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
