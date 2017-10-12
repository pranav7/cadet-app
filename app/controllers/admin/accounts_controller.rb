class Admin::AccountsController < Admin::AdminController
  def index
    @accounts = current_company.accounts
    @account = current_company.accounts.new
  end

  def show
    @account = current_company.accounts.find(params[:id])
    @account_membership = @account.account_memberships.new
    @customers = current_company.customers
    @board = current_company.boards.friendly.find(params[:board]) if params[:board]
    @posts = @account.posts(@board)
  end

  def create
    @account = current_company.accounts.new(account_params)
    @account.save

    redirect_to admin_accounts_path
  end

  private

  def account_params
    params.require(:account).permit(:name, :domain, :paying, :churned, :mrr)
  end
end
