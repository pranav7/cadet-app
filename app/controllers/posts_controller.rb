class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def show
    @board = current_company.boards.friendly.find(params[:board_id])
    @post = @board.posts.friendly.find(params[:id])
    @comment = @post.comments.new
    @comment.build_content

    @page_title = @post.title
  end

  def create
    board = current_company.boards.friendly.find(params[:board_id])
    post = board.posts.new(post_params)
    
    if post_params[:user_id] && not(post_params[:user_id] == "")
      requester = User.find post_params[:user_id]
      post.added_by = current_user
    else
      requester = current_user
    end
    
    post.requester = requester
    if post.save
      # @todo Move this to VotesService
      post.votes.create(user: requester)

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

  private

  def post_params
    params.require(:post).permit(:title, :status, :user_id, content_attributes: [:body])
  end
end
