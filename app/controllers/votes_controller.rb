class VotesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    post = current_company.posts.find(params[:post_id])
    post.votes.create(user: current_user)
    
    unless current_user.part_of?(current_company)
      current_user.companies << current_company
    end

    respond_to do |format|
      format.html do
        redirect_back fallback_location: post_path(post)
      end
    end
  end

  def destroy
    post = current_company.posts.find(params[:post_id])
    vote = Vote.where(post: post, user: current_user).first
    vote.destroy!
    redirect_back fallback_location: post_path(post)
  end
end
