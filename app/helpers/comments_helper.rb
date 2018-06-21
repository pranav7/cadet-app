module CommentsHelper
  def is_commenter?(comment)
    return false unless comment.class == Comment

    comment.commenter == current_user
  end
end
