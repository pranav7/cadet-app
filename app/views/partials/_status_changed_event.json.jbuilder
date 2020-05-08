json.admin do
  json.partial! 'partials/user_show', user: activity.event.changed_by
end
json.old_value activity.event.old_value
json.new_value activity.event.new_value