json.id @post.id
json.slug @post.slug
json.title @post.title
json.status @post.status
json.upvoted user_signed_in? ? current_user.voted?(@post) : false
json.votes_count @post.votes.count

json.content do
  json.body @post.content.body
  json.summary @post.content.summary
end

json.requester do
  json.name @post.requester.name
  json.email @post.requester.email
  json.role @post.requester.membership_for(current_company).role
end

json.comments do
  json.array! @post.comments do |comment|
    json.id comment.id
    json.content do
      json.body simple_format(comment.content.parsed)
    end
    json.commenter do
      json.name comment.commenter.name
      json.role comment.commenter.membership_for(current_company).role
    end
  end
end

json.voters do
  json.array! @post.voters do |voter|
    json.name voter.name
    json.role voter.membership_for(current_company).role
  end
end
