class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def show
    @board = current_company.boards.friendly.find(params[:board_id])
    @post = @board.posts.friendly.find(params[:id])
    @comment = @post.comments.new
    @comment.build_content

    @page_title = @post.title
  end

  def index
    @board = current_company.boards.friendly.find(params[:board_id])
    if params[:search] && params[:search] != ""
      posts = Post.arel_table
      @posts = @board.posts.where(posts[:title].matches("%#{params[:search]}%"))
    else
      @posts = @board.posts.sorted(sort_method: params[:sort_by])
    end
  end

  def create
    board = current_company.boards.friendly.find(params[:board_id])
    post = board.posts.new(post_params) 
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
      redirect_to admin_board_post_path(board, post)
    else
      redirect_to board_path(board)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :status, content_attributes: [:body])
  end
end
