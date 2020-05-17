namespace :activity_log_migration do
  task backfill_comment_created_events: :environment do
    puts "Total Comments: #{Comment.count}"
    puts "Total CommentCreatedEvents: #{CommentCreatedEvent.count}"
    puts "🟡 Started ..."

    Comment.find_each do |comment|
      next if comment.comment_created_event

      puts "Backfill #{comment.id} ..."
      company = comment.company
      post = comment.post
      user = comment.commenter

      ActiveRecord::Base.transaction do
        event = CommentCreatedEvent.create(
          comment_id: comment.id,
          user_id: user.id,
          company_id: company.id,
          post_id: post.id
        )

        ActivityLog.create(
          event_type: ::Constants::EventTypes::COMMENT_CREATED,
          event_id: event.id,
          company_id: company.id,
          post_id: post.id,
          visibility: comment.note? ? ::Constants::Visibility::PRIVATE : ::Constants::Visibility::PUBLIC
        )
      end
    end

    puts "Total Comments: #{Comment.count}"
    puts "Total CommentCreatedEvents: #{CommentCreatedEvent.count}"
    puts "✅ Done!"
  end
end
