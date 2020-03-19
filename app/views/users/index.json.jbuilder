json.users do
  json.array! @users do |user|
    json.username user.username
    json.name user.name
    json.admin user.admin_of? current_company
    json.email user.email
    json.id user.id
  end
end
