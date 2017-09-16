class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize!
  layout 'admin'

  def authorize!
    return redirect_to(boards_path) unless current_user.admin_of?(current_company)
  end
end
