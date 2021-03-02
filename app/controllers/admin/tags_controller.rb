class Admin::TagsController < Admin::AdminController
  def index
    puts current_company.boards
    puts "All"
    @tags = current_company.boards.map{ |b| b.posts.map{ |p| p.tags.map{ |t| t.name } } }.flatten
    @tags = @tags.to_set.to_a
    puts @tags
  end

  def search
    puts 'Inside search'
    search_tags = params[:tags_list]
    puts search_tags
    @posts = current_company.boards.map{ |b| b.posts.select{ |p| (search_tags - p.tags.map{ |t| t.name }).empty? } }.flatten
    render :json => @posts
  end

  def tag_params
    params.require(:tag).permit(:tags_list)
  end


end
