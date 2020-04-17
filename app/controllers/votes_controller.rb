class VotesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_post

  def create
    voter = find_voter
    Votes::Create.run!(post: @post, voter: voter)

    respond_to do |format|
      format.html do
        flash[:success] = "Vote for #{voter.name} was added" if params[:user_id]
        redirect_back fallback_location: board_post_path(@board, @post)
      end

      format.json do
        head :created
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

    respond_to do |format|
      format.html do
        redirect_back fallback_location: board_post_path(@board, @post)
      end

      format.json do
        head :ok
      end
    end
  end

  private

  def load_post
    @board = current_company.boards.friendly.find(params[:board_id])
    @post = @board.posts.friendly.find(params[:post_id])
  end

  def find_voter
    return User.find(params[:user_id]) if params[:user_id]
    current_user
  end
end
