json.id comment.id
json.private comment.private
json.created_at render_time(comment.created_at, format: :short)
json.content do
  json.body simple_format(comment.content.parsed)
  json.raw comment.content.body
end
json.commenter do
  json.partial! 'partials/user_show', user: comment.commenter
end
