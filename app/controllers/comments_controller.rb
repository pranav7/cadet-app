class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    board = current_company.boards.friendly.find(params[:board_id])
    post = board.posts.find(params[:post_id])
    comment = post.comments.new(comment_params)
    comment.user = current_user
    comment.save

    redirect_back fallback_location: board_post_path(board, post)
  end

  private

  def comment_params
    params.require(:comment).permit(content_attributes: [:body])
  end
end
