class Admin::UsersController < Admin::AdminController
  def index
    @users = current_company.users.order(created_at: :desc).compact
    @user = User.new
    @main_selected = :customers
    @sub_nav_selected = :users
  end

  def show
    @user = current_company.users.find(params[:id])
    @main_selected = :customers
    @sub_nav_selected = :users

    if params[:board]
      @board = current_company.boards.friendly.find(params[:board])
      @posts = @user.voted_posts.sorted(sort_method: params[:sort_by])
    end
  end
end
