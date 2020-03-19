json.id @post.id
json.slug @post.slug
json.title @post.title
json.status @post.status
json.upvoted user_signed_in? ? current_user.voted?(@post) : false
json.votes_count @post.votes.count
json.created_at render_time(@post.created_at, format: :short)
json.test_slug @post.slug

json.content do
  json.body simple_format(@post.content.parsed) # Backward support

  json.html simple_format(@post.content.parsed)
  json.raw @post.content.body
  json.summary @post.content.summary
end

json.requester do
  json.name @post.requester.name
  json.initials @post.requester.initials
  json.email @post.requester.email
  json.role @post.requester.membership_for(current_company).role
  json.id @post.requester.id
end

json.comments do
  json.array! @post.comments do |comment|
    json.id comment.id
    json.private comment.private
    json.created_at render_time(comment.created_at, format: :short)

    json.content do
      json.body simple_format(comment.content.parsed)
    end

    json.commenter do
      json.name comment.commenter.name
      json.initials comment.commenter.initials
      json.role comment.commenter.membership_for(current_company).role
    end
  end
end

json.voters do
  json.array! @post.voters do |voter|
    json.id voter.id
    json.name voter.name
    json.initials voter.initials
    json.role voter.membership_for(current_company).role
  end
end
