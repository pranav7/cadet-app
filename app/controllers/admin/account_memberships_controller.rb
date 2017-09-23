class Admin::AccountMembershipsController < Admin::AdminController
  def create
    account = current_company.accounts.find(params[:account_id])
    users = User.find params[:user_ids]
    users.each do |user|
      account_membership = account.account_memberships.new(user: user)
      account_membership.save
    end

    redirect_to admin_account_path(account)
  end
end
