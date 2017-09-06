class PostsController < ApplicationController
  before_action :authenticate_user!

  def show
    @post = current_company.posts.find(params[:id])
    @comment = @post.comments.new
    @comment.build_content
  end

  def index
    @posts = current_company.posts.order(created_at: :desc).includes(:comments)
    @post = current_company.posts.new
    @post.build_content
  end

  def new;end

  def create
    post = current_company.posts.new(post_params)
    post.user = current_user
    post.save
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, content_attributes: [:body])
  end
end
