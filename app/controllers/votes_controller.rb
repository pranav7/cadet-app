class VotesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_post

  def create
    if params[:user_id]
      user = User.find params[:user_id]
      @post.votes.create(user: user, added_by: current_user)
    else
      user = current_user
      @post.votes.create(user: user)
    end
    
    unless user.part_of?(current_company)
      user.companies << current_company
    end

    respond_to do |format|
      format.html do
        flash[:success] = "Vote for #{user.name} was added" if params[:user_id]
        redirect_back fallback_location: board_post_path(@board, @post)
      end
    end
  end

  def destroy
    if params[:user_id]
      user = User.find params[:user_id]
    else
      user = current_user
    end

    vote = Vote.where(post: @post, user: user).first
    vote.destroy!
    redirect_back fallback_location: board_post_path(@board, @post)
  end

  private

  def load_post
    @board = current_company.boards.friendly.find(params[:board_id])
    @post = @board.posts.friendly.find(params[:post_id])
  end
end
