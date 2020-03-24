class Admin::PostsController < Admin::AdminController
  before_action :find_board!

  def show
    @post = @board.posts.friendly.find(params[:id])
    @main_selected = :boards
  end

  def create
    post = @board.posts.new(post_params)

    if post_params[:user_id] && (post_params[:user_id] != "")
      requester = User.find(post_params[:user_id])
      post.added_by = current_user
      post.votes.build(user: requester, added_by: current_user)
    else
      requester = current_user
      post.votes.build(user: requester)
    end

    post.requester = requester

    if post.save
      requester.companies << current_company unless requester.part_of?(current_company)
    else
      # Hanlde Post Error
    end

    respond_to do |format|
      format.json do
        render json: { post: { slug: post.slug } }, status: :created
      end

      format.html do
        if params[:after_create_path] == "admin"
          redirect_to admin_board_post_path(@board, post)
        else
          redirect_to board_path(@board)
        end
      end
    end
  end

  def update
    @post = @board.posts.friendly.find(params[:id])
    @post.assign_attributes(post_params)

    # slug needs to be set to nil to regenerate slug
    @post.slug = nil if @post.title_changed?

    add_voter if @post.user_id_changed?

    if @post.save
      flash[:success] = "Changes to post saved"
    else
      flash[:error] = "Something went wrong"
    end

    respond_to do |format|
      format.json do
        head :ok
      end

      format.html do
        redirect_back fallback_location: admin_board_post_path(@post)
      end
    end
  end

  def destroy
    post = @board.posts.friendly.find(params[:id])

    begin
      post.destroy!

      flash[:success] = "Post was deleted!"
      redirect_to admin_board_path(post.board)
    rescue StandardError
      flash[:error] = "Something went wrong while deleting the post"
      redirect_to board_post_path(@board, post)
    end
  end

  private

  def find_board!
    @board = current_company.boards.friendly.find(params[:board_id])
  end

  def post_params
    params.require(:post).permit(:title, :status, :user_id, content_attributes: [:body])
  end

  def add_voter
    requester = User.find post_params[:user_id]
    @post.votes.build(user: requester, added_by: current_user)
  end
end
