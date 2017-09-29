class Admin::AccountMembershipsController < Admin::AdminController
  def create
    account = current_company.accounts.find(params[:account_id])
    users = User.find params[:user_ids].split(",")
    users.each do |user|
      account_membership = account.account_memberships.new(user: user)
      account_membership.save
    end

    redirect_to admin_account_path(account)
  end

  def destroy
    account_membership = AccountMembership.where(user_id: params[:user_id], account_id: params[:account_id]).first
    account_membership.destroy!
    flash[:success] = "User removed"
    redirect_to admin_account_path(params[:account_id])
  end
end
