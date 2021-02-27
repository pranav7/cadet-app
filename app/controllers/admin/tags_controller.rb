class Admin::TagsController < Admin::AdminController
  def index
    puts current_company.boards
    puts "All"
    @tags = current_company.boards.map{ |b| b.posts.map{ |p| p.tags.map{ |t| t.name } } }.flatten
    puts @tags
  end

  def show
    @posts = Article.find(params[:id])
  end

end
