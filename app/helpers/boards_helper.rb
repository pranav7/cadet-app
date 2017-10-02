module BoardsHelper
  def board_link(board, options = {})
    to_admin = options.delete(:to_admin)

    if to_admin
      admin_board_path(board)
    else
      board_path(board)
    end
  end
end
