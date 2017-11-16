class Admin::AccountsController < Admin::AdminController
  def index
    @accounts = current_company.accounts
    @account = current_company.accounts.new
    @main_selected = :customers
    @sub_nav_selected = :accounts
  end

  def show
    @account = current_company.accounts.find(params[:id])
    @account_membership = @account.account_memberships.new
    @users = current_company.users
    @main_selected = :customers
    @sub_nav_selected = :accounts

    if params[:board]
      @board = current_company.boards.friendly.find(params[:board])
      @posts = @account.posts(@board).sorted(sort_method: params[:sort_by])
    end
  end

  def create
    @account = current_company.accounts.new(account_params)
    @account.save

    redirect_to admin_accounts_path
  end

  def edit
    @account = current_company.accounts.find(params[:id])
    @account_membership = @account.account_memberships.new
    @users = current_company.users
    @board = current_company.boards.friendly.find(params[:board]) if params[:board]
    @posts = @account.posts(@board)
  end

  def update
    @account = current_company.accounts.find(params[:id])

    if @account.update_attributes(account_params)
      flash[:success] = "Account updated!"
      redirect_to admin_account_path(@account, request.query_parameters)
    else
      render :edit
    end
  end

  def destroy
    @account = current_company.accounts.find(params[:id])
    @account.destroy!
    flash[:success] = "Account deleted!"
    redirect_to admin_accounts_path
  end

  private

  def account_params
    params.require(:account).permit(:name, :domain, :paying, :churned, :mrr)
  end
end
