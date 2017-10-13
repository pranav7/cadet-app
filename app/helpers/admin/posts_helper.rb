module Admin::PostsHelper
  def post_endpoint(board, post, options = {})
    after_create_path = options.delete(:after_create_path) || :public

    if post.new_record?
      board_posts_path(board, after_create_path: after_create_path)
    else
      admin_board_post_path(board, post)
    end
  end

  def post_heading(post)
    if post.new_record?
      "Create Post"
    else
      "Edit Post"
    end
  end

  def post_button(post)
    if post.new_record?
      "Create Post"
    else
      "Save"
    end
  end
end
