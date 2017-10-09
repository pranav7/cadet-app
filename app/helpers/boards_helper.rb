module BoardsHelper
  def board_link(board, options = {})
    to_admin = options.delete(:to_admin)

    if to_admin
      if board.posts.blank?
        admin_board_path(board)
      else
        admin_board_post_path(board, board.posts.first)
      end
    else
      board_path(board)
    end
  end
end
