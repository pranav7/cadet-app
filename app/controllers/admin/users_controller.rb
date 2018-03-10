class Admin::UsersController < Admin::AdminController
  before_action :set_selected_menu_items

  def index
    @users = current_company.users.order(created_at: :desc).compact
    @user = User.new
  end

  def show
    @user = current_company.users.find(params[:id])

    if params[:board]
      @board = current_company.boards.friendly.find(params[:board])
      @posts = @user.voted_posts.where(board: @board).sorted(sort_method: params[:sort_by])
    end
  end

  def edit
    @user = current_company.users.find(params[:id])
  end

  def update
    @user = current_company.users.find(params[:id])

    unless user_policy.editable?
      flash[:error] = "You do not have access to edit this user"
      return redirect_to admin_user_path(@user)
    end

    @user.assign_attributes(user_params)

    if user_params[:role]
      @membership = @user.membership_for(current_company)
      @membership.role = user_params[:role].downcase
    end

    @user.transaction do
      @user.save!
      @membership.save! if @membership
    end

    flash[:success] = "Your changes were saved!"
    redirect_to admin_user_path(@user)
  end

  private

  def set_selected_menu_items
    @main_selected = :customers
    @sub_nav_selected = :users
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role)
  end

  def user_policy
    @user_policy ||= UserPolicy.new(current_company: current_company, current_user: current_user, resource: @user)
  end
  helper_method :user_policy
end
