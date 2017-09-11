class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

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

  def update
    post = current_company.posts.find(params[:id])
    post.update_attributes(post_params)

    redirect_back fallback_location: post_path(post)
  end

  private

  def post_params
    params.require(:post).permit(:title, :status, content_attributes: [:body])
  end
end
