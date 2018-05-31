class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :load_post

  def create
    comment = @post.comments.new(comment_params)
    comment.commenter = current_user
    comment.save

    unless current_user.part_of?(current_company)
      current_user.companies << current_company
    end

    redirect_back fallback_location: board_post_path(@board, @post)
  end

  def destroy
    comment = @post.comments.find(params[:id])
    comment.destroy

    flash[:success] = "Deleted."
    redirect_back fallback_location: board_post_path(@board, @post)
  end

  private

  def comment_params
    params.require(:comment).permit(:private, content_attributes: [:body])
  end

  def load_post
    @board = current_company.boards.friendly.find(params[:board_id])
    @post = @board.posts.friendly.find(params[:post_id])
  end
end
