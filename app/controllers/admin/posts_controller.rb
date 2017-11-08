class Admin::PostsController < Admin::AdminController
  def show
    @board = current_company.boards.friendly.find(params[:board_id])
    @posts = @board.posts.sorted(sort_method: params[:sort_by])
    @post = @board.posts.friendly.find(params[:id]) || @posts.first || nil

    @new_post = @board.posts.new
    @new_post.build_content

    @comment = @post.comments.new
    @comment.build_content

    @accounts = @post.accounts
  end

  def update
    board = current_company.boards.friendly.find(params[:board_id])
    post = board.posts.friendly.find(params[:id])
    # slug needs to be set to nil to regenerate slug
    post.slug = nil

    if post.update_attributes(post_params)
      flash[:success] = "Changes to post saved"
    else
      flash[:error] = "Something went wrong"
    end

    redirect_back fallback_location: admin_board_post_path(post)
  end

  private

  def post_params
    params.require(:post).permit(:title, :status, content_attributes: [:body])
  end
end
