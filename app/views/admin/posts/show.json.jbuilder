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
  json.array! @post.comments.chronologically do |comment|
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
  end
end

json.voters do
  json.array! @post.voters do |voter|
    json.id voter.id
    json.name voter.name
    json.initials voter.initials
    json.role voter.membership_for(current_company).role
    json.job_title voter.job_title
    json.company_name voter.account_for(current_company)&.name || ""
    json.deletable !voter.votes.where(post: @post).first.manual?
  end
end

json.accounts do
  json.array! @post.accounts do |account|
    json.id account.id
    json.name account.name
    json.votes account.votes_for(@post).count
    json.mrr account.mrr
  end
end

json.activity_log do
  json.array! @post.activity_log do |activity|
    json.event_type activity.event_type
    json.created_at render_time(activity.created_at, format: :short)

    if activity.event_type == Constants::EventTypes::COMMENT_CREATED
      json.event do
        json.visibility activity.visibility
        json.comment do
          json.partial! 'comments/show', comment: activity_log.event.comment
        end
      end
    end

    if activity.event_type == Constants::EventTypes::STATUS_CHANGED
      json.event do
        json.admin_username User.find(StatusChangedEvent.find(activity.event_id).admin_id).name
        json.old_value activity.event.old_value
        json.new_value activity.event.new_value
      end
    end
  end
end
