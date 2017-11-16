class Admin::UsersController < Admin::AdminController
  def index
    @users = current_company.customers.compact
    @main_selected = :customers
    @sub_nav_selected = :users
  end
end
