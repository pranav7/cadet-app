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
    @comment = @post.comments.find(params[:id])

    respond_to do |format|
      if authorized? and @comment.update_attributes(comment_params)
        flash[:success] = "Changes saved." 

        format.html do
          redirect_back fallback_location: board_post_path(@board, @post)
        end
  
        format.json do
          head :ok
        end
      else
        flash[:error] = "Something went wrong, your changes were not saved."
      end
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    respond_to do |format|
      if authorized?
        @comment.destroy!
        
        format.html do
          flash[:success] = "Deleted."
          redirect_back fallback_location: board_post_path(@board, @post)
        end
  
        format.json do
          head :ok
        end
      else
        format.html do
          flash[:error] = "That action is not allowed."
          redirect_back fallback_location: board_post_path(@board, @post)
        end

        format.json do
          head :unauthorized
        end
      end
    end
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
