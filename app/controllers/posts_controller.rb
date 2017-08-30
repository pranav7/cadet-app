class PostsController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc)
    @post = Post.new
    @post.build_content
  end

  def new;end

  def create
    post = Post.new(post_params)
    post.save
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, content_attributes: [:body])
  end
end
