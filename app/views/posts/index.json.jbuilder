json.posts do
  json.array! @posts do |post|
    json.id post.id
    json.slug post.slug
    json.title post.title
    json.summary post.content.summary
    json.url board_post_url(@board, post)
    json.comments_count post.comments.without_notes.count
    json.votes_count post.votes.count
    json.upvoted user_signed_in? ? current_user.voted?(post) : false
    json.created_at render_time(post.created_at, format: :short)
    json.created_by post.requester.name
    json.status post.status
  end
end
