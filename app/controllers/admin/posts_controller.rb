class Admin::PostsController < Admin::AdminController
  def show
    @board = current_company.boards.friendly.find(params[:board_id])
    @posts = @board.posts.order(created_at: :desc).includes(:comments)
    @post = Post.friendly.find(params[:id]) || @posts.first || nil
    @comment = @post.comments.new
    @comment.build_content
    @accounts = @post.accounts
  end

  def update
    board = current_company.boards.friendly.find(params[:board_id])
    post = board.posts.friendly.find(params[:id])
    post.update_attributes(post_params)

    redirect_back fallback_location: admin_board_post_path(post)
  end

  private

  def post_params
    params.require(:post).permit(:title, :status, content_attributes: [:body])
  end
end
