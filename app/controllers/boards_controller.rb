class BoardsController < ApplicationController
  def index
    if user_signed_in? && current_user.admin_of?(current_company)
      @boards = current_company.boards
    else
      @boards = current_company.boards.non_private
    end

    if @boards.count == 1
      return redirect_to(board_path(@boards.first))
    end

    @page_title = "Boards - #{current_company.name}"
  end

  def show
    @board = current_company.boards.friendly.find(params[:id])
    authorize_admin_access! if @board.private?

    @posts = @board.posts.sorted(sort_method: params[:sort_by])
    @post = @board.posts.new
    @post.build_content
    @page_title = "#{@board.name} - #{current_company.name}"
  end
end
