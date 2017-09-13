class Admin::PostsController < Admin::AdminController
  def show
    @board = current_company.boards.find(params[:board_id])
    @posts = @board.posts.order(created_at: :desc).includes(:comments)
    @post = Post.find(params[:id]) || @posts.first || nil
    @comment = @post.comments.new
    @comment.build_content
  end

  def index
    @posts = current_company.posts.order(created_at: :desc).includes(:comments)
    redirect_to admin_post_path(@posts.first) unless @posts.empty?
  end

  def update
    board = current_company.boards.find(params[:board_id])
    post = board.posts.find(params[:id])
    post.update_attributes(post_params)

    redirect_back fallback_location: admin_board_post_path(post)
  end

  private

  def post_params
    params.require(:post).permit(:title, :status, content_attributes: [:body])
  end
end
