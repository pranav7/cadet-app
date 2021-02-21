class Changelog::EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize!

  def new
    @entry = current_company.changelog_entries.new
    @entry.build_content
  end

  def create
    @entry = current_company.changelog_entries.new(entry_params)
    params[:changelog_entry][:status] = convert_status(params[:changelog_entry][:status])

    if @entry.save
      redirect_to changelog_url
    else
      render :new
    end
  end

  def edit
    @entry = current_company.changelog_entries.friendly.find(params[:id])
  end

  def update
    @entry = current_company.changelog_entries.friendly.find(params[:id])
    params[:changelog_entry][:status] = convert_status(params[:changelog_entry][:status])

    if @entry.update(entry_params)
      redirect_to changelog_url
    else
      render :edit
    end
  end

  def destroy
    @entry = current_company.changelog_entries.friendly.find(params[:id])
    @entry.destroy

    redirect_to changelog_url
  end

  def convert_status(entry_status)
    case entry_status
    when 'New'
      0
    when 'Improvement'
      1
    when 'Fix'
      2
    end
  end

  private
  def entry_params
    params.require(:changelog_entry).permit(:title, :status, content_attributes: [:body])
  end

  def authorize!
    redirect_to(changelog_url) unless current_user.admin_of?(current_company)
  end
end
