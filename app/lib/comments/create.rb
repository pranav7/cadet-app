module Comments
  class Create < Base
    attr_reader :post, :is_private, :content, :commenter

    def validate!
      validate_user_has_permission
    end

    def run!
      create_comment
    end

    private

    def create_comment
      comment = @post.comments.new(
        post_id: @post.id,
        content_attributes: @content,
        private: @is_private
      )
      comment.commenter = @commenter
      comment.save!

      ActiveRecord::Base.transaction do
        log_activity(comment)
      end
      Current.user.companies << Current.company unless Current.user.part_of?(Current.company)
    end

    def log_activity(comment)
      event = CommentCreatedEvent.create(
        comment_id: comment.id,
        user_id: Current.user.id,
        company_id: comment.post.company.id,
        post_id: @post.id
      )

      ActivityLog.create(
        event_type: Constants::EventTypes::COMMENT_CREATED,
        event_id: event.id,
        company_id: @post.company.id,
        visibility: @is_private ? Constants::Visibility::PRIVATE : Constants::Visibility::PUBLIC,
        post_id: @post.id
      )
    end
  end
end
