class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:id])
    comment = post.comments.new(comment_params)
    comment.user = current_user
    comment.save

    redirect_to post_path(comment.post)
  end

  private

  def comment_params
    params.require(:comment).permit(content_attributes: [:body])
  end
end
