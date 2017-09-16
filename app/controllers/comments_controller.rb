class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :load_post

  def create
    comment = @post.comments.new(comment_params)
    comment.user = current_user
    comment.save

    redirect_back fallback_location: board_post_path(@board, @post)
  end

  private

  def comment_params
    params.require(:comment).permit(content_attributes: [:body])
  end

  def load_post
    @board = current_company.boards.friendly.find(params[:board_id])
    @post = @board.posts.friendly.find(params[:post_id])
  end
end
