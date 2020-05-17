module PostsHelper
  def build_post_link(post, options = {})
    link_to = options.delete(:link_to) || :public

    return admin_board_post_path(post.board, post) if link_to == :admin

    board_post_path(post.board, post)
  end
end
