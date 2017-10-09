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
    @board = current_company.boards.friendly.find(params[:id])
    if @board.posts.blank?
      @post = @board.posts.new
      @post.build_content
    else
      redirect_to admin_board_post_path(@board, @board.posts.first)
    end
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
