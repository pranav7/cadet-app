class Admin::PostsController < Admin::AdminController
  def show
    @posts = current_company.posts.order(created_at: :desc).includes(:comments)
    @post = Post.find(params[:id]) || @posts.first
    @comment = @post.comments.new
    @comment.build_content
  end

  def index
    @posts = current_company.posts.order(created_at: :desc).includes(:comments)
    redirect_to admin_post_path(@posts.first)
  end
end
