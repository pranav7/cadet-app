class PostsController < ApplicationController
  def index
  end

  def new; end

  def create
    post = Post.new(post_params)
    post.save
  end

  private

  def post_params
    params.require(:post).permit(:title, content_attributes: [:body])
  end
end
