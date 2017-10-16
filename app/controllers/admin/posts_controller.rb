class Admin::PostsController < Admin::AdminController
  def show
    @board = current_company.boards.friendly.find(params[:board_id])
    get_posts_and_apply_filter
    @post = Post.friendly.find(params[:id]) || @posts.first || nil

    @new_post = @board.posts.new
    @new_post.build_content

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

  def get_posts_and_apply_filter
    if params[:sort_by] && params[:sort_by] != ""
      @posts = @board.posts.public_send(params[:sort_by]).includes(:comments)
    else
      @posts = @board.posts.latest_activity.includes(:comments)
    end
  end
end
