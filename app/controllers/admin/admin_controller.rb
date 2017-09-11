class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize!
  layout 'admin'

  def authorize!
    unless current_user.companies.include?(current_company)
      redirect_to posts_path
    end
  end
end
