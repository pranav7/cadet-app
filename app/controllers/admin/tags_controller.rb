class Admin::TagsController < Admin::AdminController
  def index
    @tags = current_company.boards.map { |b| b.posts.map { |p| p.tags.map(&:name) } }.flatten
    @tags = @tags.to_set.to_a
  end

  def search
    search_tags = params[:tags_list]
    @posts = current_company.boards.map { |b| b.posts.select { |p| (search_tags - p.tags.map(&:name)).empty? } }.flatten
  end

  def tag_params
    params.require(:tag).permit(:tags_list)
  end
end
