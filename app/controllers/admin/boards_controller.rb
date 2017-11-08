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
      @boards = current_company.boards
      render action: :index
    end
  end

  def edit
    @board = current_company.boards.friendly.find(params[:id])
  end

  def update
    @board = current_company.boards.friendly.find(params[:id])
    # slug needs to be set to nil to regenerate slug
    @board.slug = nil

    if @board.update_attributes(board_params)
      flash[:success] = "Settings saved"
      redirect_to edit_admin_board_path(@board)
    else
      render action: :edit
    end
  end

  def show
    @board = current_company.boards.friendly.find(params[:id])

    if @board.posts.blank?
      @post = @board.posts.new
      @post.build_content
    else
      redirect_to admin_board_post_path(@board, @board.posts.sorted(sort_method: params[:sort_by]).first)
    end
  end

  def index
    @boards = current_company.boards
    @board = current_company.boards.new
  end

  def destroy
    @board = current_company.boards.friendly.find(params[:id])
    @board.destroy!

    flash[:success] = "Board and all it's posts were deleted"
    redirect_to admin_boards_path
  end

  private

  def board_params
    params.require(:board).permit(:name, :description)
  end
end
