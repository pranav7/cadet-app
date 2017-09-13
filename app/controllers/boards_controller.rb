class BoardsController < ApplicationController
  def index
    @boards = current_company.boards
  end

  def show
    @board = current_company.boards.find(params[:id])
    @posts = @board.posts.order(created_at: :desc).includes(:comments)
    @post = current_company.posts.new
    @post.build_content
  end
end
