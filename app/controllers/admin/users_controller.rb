class Admin::UsersController < Admin::AdminController
  before_action :set_selected_menu_items

  def index
    if params[:role] && params[:role] == "admin"
      @users = current_company.admins
    elsif params[:role] && params[:role] == "customer"
      @users = current_company.customers
    else
      @users = current_company.users
    end
    @user = User.new
  end

  def show
    @user = current_company.users.find(params[:id])

    return if params[:board].blank?

    @board = current_company.boards.friendly.find(params[:board])
    @posts = @user.voted_posts.where(board: @board).sorted(sort_method: params[:sort_by])
  end

  def edit
    @user = current_company.users.find(params[:id])
  end

  def update
    @user = current_company.users.find(params[:id])

    @user.assign_attributes(user_params) if user_policy.editable?

    if user_params[:role]
      @membership = @user.membership_for(current_company)
      @membership.role = user_params[:role].downcase
    end

    begin
      @user.transaction do
        @user.save!
        @membership&.save!
      end

      flash[:success] = "Your changes were saved!"
      redirect_to admin_user_path(@user)
    rescue StandardError
      flash[:error] = "We couldn't save the changes"
      render :edit
    end
  end

  private
  def set_selected_menu_items
    @main_selected = :customers
    
    if params[:role] && params[:role] == "admin"
      @sub_nav_selected = :admins
    elsif params[:role] && params[:role] == "customer"
      @sub_nav_selected = :customers
    else
      @sub_nav_selected = :admins
    end
    
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :job_title)
  end

  def user_policy
    @user_policy ||= UserPolicy.new(current_company: current_company, current_user: current_user, resource: @user)
  end
  helper_method :user_policy
end
