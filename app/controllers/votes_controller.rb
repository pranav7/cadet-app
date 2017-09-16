class VotesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_post

  def create
    @post.votes.create(user: current_user)
    
    unless current_user.part_of?(current_company)
      current_user.companies << current_company
    end

    respond_to do |format|
      format.html do
        redirect_back fallback_location: board_post_path(@board, @post)
      end
    end
  end

  def destroy
    vote = Vote.where(post: @post, user: current_user).first
    vote.destroy!
    redirect_back fallback_location: board_post_path(@board, @post)
  end

  private

  def load_post
    @board = current_company.boards.friendly.find(params[:board_id])
    @post = @board.posts.find(params[:post_id])
  end
end
