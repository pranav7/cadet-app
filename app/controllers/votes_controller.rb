class VotesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :load_post

  def create
    if params[:user_id]
      user = User.find params[:user_id]
      if not @post.voters.where(id: user.id).first
        @post.votes.create(user: user, added_by: current_user)
        respond_to do |format|
          format.html do
            flash[:success] = "Vote for #{user.name} was added" if params[:user_id]
            redirect_back fallback_location: board_post_path(@board, @post)
          end

          format.json do
            head :created
          end
        end
      else
        respond_to do |format|
          format.html do
            flash[:success] = "Vote for #{user.name} was already added" if params[:user_id]
            redirect_back fallback_location: board_post_path(@board, @post)
          end

          format.json do
            head :ok
          end
        end
      end
    else
      user = current_user
      if not @post.voters.where(id: user.id).first
        @post.votes.create(user: user)
        respond_to do |format|
          format.html do
            flash[:success] = "Vote for #{user.name} was added" if params[:user_id]
            redirect_back fallback_location: board_post_path(@board, @post)
          end

          format.json do
            head :created
          end
        end
      else
        respond_to do |format|
          format.html do
            flash[:success] = "Vote for #{user.name} was already added" if params[:user_id]
            redirect_back fallback_location: board_post_path(@board, @post)
          end
    
          format.json do
            head :ok
          end
        end
      end
    end

    user.companies << current_company unless user.part_of?(current_company)
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
end
