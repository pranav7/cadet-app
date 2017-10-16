class BoardsController < ApplicationController
  def index
    @boards = current_company.boards
    @page_title = "Boards - #{current_company.name}"
  end

  def show
    @board = current_company.boards.friendly.find(params[:id])

    get_posts_and_apply_filter

    @post = @board.posts.new
    @post.build_content
    @page_title = "#{@board.name} - #{current_company.name}"
  end

  private

  def get_posts_and_apply_filter
    if params[:sort_by] && params[:sort_by] != ""
      @posts = @board.posts.public_send(params[:sort_by]).includes(:comments)
    else
      @posts = @board.posts.latest_activity.includes(:comments)
    end
  end
end
