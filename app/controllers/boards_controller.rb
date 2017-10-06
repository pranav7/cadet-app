class BoardsController < ApplicationController
  def index
    @boards = current_company.boards
    @page_title = "Boards - #{current_company.name}"
  end

  def show
    @board = current_company.boards.friendly.find(params[:id])
    @posts = @board.posts.order(created_at: :desc).includes(:comments)
    @post = @board.posts.new
    @post.build_content
    @page_title = "#{@board.name} - #{current_company.name}"
  end
end
