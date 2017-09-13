class Admin::BoardsController < Admin::AdminController
  def new
    @board = current_company.boards.new
  end

  def create
    @board = current_company.boards.new(board_params)

    if @board.save
      flash[:success] = "Board created!"
      redirect_to admin_boards_path
    else
      flash[:error] = "There was an error while creating your board"
      render action: :new
    end
  end

  def show
    @board = current_company.boards.find(params[:id])
    @posts = @board.posts.order(created_at: :desc).includes(:comments)
    redirect_to admin_board_post_path(@board, @posts.first)
  end

  def index
    @boards = current_company.boards
    @board = current_company.boards.new
  end

  private

  def board_params
    params.require(:board).permit(:name, :description)
  end
end
