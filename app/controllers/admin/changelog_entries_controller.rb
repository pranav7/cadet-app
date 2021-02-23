class Admin::ChangelogEntriesController < Admin::AdminController
  def new
    @entry = current_company.changelog_entries.new
    @entry.build_content
  end

  def create
    @entry = current_company.changelog_entries.new(entry_params)

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

  def index
    @main_selected = :changelog 
    @entries = current_company.changelog_entries.reverse_chronologically
  end

  private

  def entry_params
    params.require(:changelog_entry).permit(:title, :status, content_attributes: [:body])
  end

  def authorize!
    redirect_to(changelog_url) unless current_user.admin_of?(current_company)
  end
end