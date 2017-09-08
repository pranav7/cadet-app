class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    post = current_company.posts.find(params[:post_id])
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
