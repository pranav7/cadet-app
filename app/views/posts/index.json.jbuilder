json.posts do
  json.array! @posts do |post| 
    json.title post.title
    json.summary post.summary
    json.url board_post_url(@board, post)
    json.comments_count post.comments.without_notes.count
    json.created_at render_time(post.created_at, format: :short)
    json.created_by post.requester.name
  end
end
