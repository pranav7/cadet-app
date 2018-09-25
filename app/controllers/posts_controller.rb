class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :get_and_authorize_board

  def new
    @post = @board.posts.new
    @post.build_content
  end

  def show
    @post = @board.posts.friendly.find(params[:id])
    @comment = @post.comments.new
    @comment.build_content

    @page_title = @post.title
  end

  def index
    if params[:search] && params[:search] != ""
      @posts = @board.posts.search(term: params[:search])
    else
      @posts = @board.posts.sorted(board: @board, sort_method: params[:sort_by]).reverse_chronologically
    end

    @posts = paginate @posts, per_page: 3
  end

  def create
    post = @board.posts.new(post_params)
    post.requester = current_user
    post.votes.build(user: current_user)

    if post.save
      unless current_user.part_of?(current_company)
        current_user.companies << current_company
      end
    else
      # Hanlde Post Error
    end

    if params[:after_create_path] == "admin"
      redirect_to admin_board_post_path(@board, post)
    else
      redirect_to board_path(@board)
    end
  end

  private
    def get_and_authorize_board
      @board = current_company.boards.friendly.find(params[:board_id])
      authorize_admin_access! if @board.private?
    end

    def post_params
      params.require(:post).permit(:title, :status, content_attributes: [:body])
    end
end
