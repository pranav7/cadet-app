class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :load_post

  def create
    comment = @post.comments.new(comment_params)
    comment.commenter = current_user
    comment.save

    current_user.companies << current_company unless current_user.part_of?(current_company)

    respond_to do |format|
      format.html do
        redirect_back fallback_location: board_post_path(@board, @post)
      end

      format.json do
        head :created
      end
    end
  end

  def update
    comment = @post.comments.find(params[:id])
    if comment.update_attributes(comment_params)
      flash[:success] = "Changes saved."
    else
      flash[:error] = "Something went wrong, your changes were not saved."
    end

    redirect_back fallback_location: board_post_path(@board, @post)
  end

  def destroy
    @comment = @post.comments.find(params[:id])

    if authorized?
      @comment.destroy
      flash[:success] = "Deleted."
    else
      flash[:error] = "That action is not allowed."
    end

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

  def authorized?
    @comment.commenter == current_user
  end
end
