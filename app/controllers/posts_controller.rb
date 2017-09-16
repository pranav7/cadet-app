class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def show
    @board = current_company.boards.friendly.find(params[:board_id])
    @post = @board.posts.friendly.find(params[:id])
    @comment = @post.comments.new
    @comment.build_content
  end

  def create
    board = current_company.boards.friendly.find(params[:board_id])
    post = board.posts.new(post_params)
    post.user = current_user
    post.save

    redirect_to board_path(board)
  end

  private

  def post_params
    params.require(:post).permit(:title, :status, content_attributes: [:body])
  end
end
