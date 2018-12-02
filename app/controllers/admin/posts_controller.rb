class Admin::PostsController < Admin::AdminController
  def show
    @board = current_company.boards.friendly.find(params[:board_id])

    if params[:search] && params[:search] != ""
      @posts = @board.posts.search(term: params[:search])
    else
      @posts = @board.posts.sorted(sort_method: params[:sort_by])
                     .reverse_chronologically
    end

    @post = @board.posts.friendly.find(params[:id]) || @posts.first || nil

    @new_post = @board.posts.new
    @new_post.build_content

    @comment = @post.comments.new
    @comment.build_content

    @accounts = @post.accounts
    @main_selected = :boards
  end

  def create
    board = current_company.boards.friendly.find(params[:board_id])
    post = board.posts.new(post_params)

    if post_params[:user_id] && (post_params[:user_id] != "")
      requester = User.find post_params[:user_id]
      post.added_by = current_user
      post.votes.build(user: requester, added_by: current_user)
    else
      requester = current_user
      post.votes.build(user: requester)
    end

    post.requester = requester
    if post.save
      unless requester.part_of?(current_company)
        requester.companies << current_company
      end
    else
      # Hanlde Post Error
    end

    if params[:after_create_path] == "admin"
      redirect_to admin_board_post_path(board, post)
    else
      redirect_to board_path(board)
    end
  end

  def update
    board = current_company.boards.friendly.find(params[:board_id])
    @post = board.posts.friendly.find(params[:id])
    # slug needs to be set to nil to regenerate slug
    @post.assign_attributes(post_params)
    @post.slug = nil if @post.title_changed?
    add_voter if @post.user_id_changed?

    if @post.save
      flash[:success] = "Changes to post saved"
    else
      flash[:error] = "Something went wrong"
    end

    redirect_back fallback_location: admin_board_post_path(@post)
  end

  def destroy
    board = current_company.boards.friendly.find(params[:board_id])
    post = board.posts.friendly.find(params[:id])

    begin
      post.destroy!

      flash[:success] = "Post was deleted!"
      redirect_to admin_board_path(post.board)
    rescue StandardError
      flash[:error] = "Something went wrong while deleting the post"
      redirect_to board_post_path(board, post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :status, :user_id, content_attributes: [:body])
  end

  def add_voter
    requester = User.find post_params[:user_id]
    @post.votes.build(user: requester, added_by: current_user)
  end
end
