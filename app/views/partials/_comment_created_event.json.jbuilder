json.visibility activity.visibility
json.comment do
  json.partial! 'comments/show', comment: activity.event.comment
end