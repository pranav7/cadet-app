class Admin::CompaniesController < Admin::AdminController
  before_action :select_menu_items

  def edit
  end

  def update
    current_company.update_attributes(company_params)
    flash[:success] = "Changes Saved!"
    redirect_to edit_admin_company_path(current_company)
  end

  private
    def select_menu_items
      @main_selected = :settings
      @sub_nav_selected = :general
    end

    def company_params
      params.require(:company).permit(:name)
    end
end
