json.id comment.id
json.private comment.private
json.created_at render_time(comment.created_at, format: :short)
json.content do
  json.body simple_format(comment.content.parsed)
  json.raw comment.content.body
end
json.commenter do
  json.id comment.commenter.id
  json.name comment.commenter.name
  json.initials comment.commenter.initials
  json.role comment.commenter.membership_for(current_company).role
end
