module Comments
  class Create
    attr_reader :post, :is_private, :content, :commenter

    def self.run!(post:, is_private:, content:, commenter:)
      service = new(post: post, is_private: is_private, content: content, commenter: commenter)
      service.validate!
      service.run!
    end

    def initialize(post:, is_private:, content:, commenter:)
      @post = post
      @is_private = is_private || false
      @content = content
      @commenter = commenter || Current.user
    end

    def validate!
      validate_user_has_permission
    end

    def run!
      create_comment
    end

    private

    def create_comment
      ActiveRecord::Base.transaction do
        comment = @post.comments.new(
          post_id: @post.id,
          content_attributes: @content,
          private: @is_private
        )
        comment.commenter = @commenter
        comment.save!

        log_activity(comment)
        Current.user.companies << Current.company unless Current.user.part_of?(Current.company)
      end
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

    def validate_user_has_permission
      return if not @is_private
      return if @is_private && Current.user.admin_of?(Current.company)
      raise Errors::AdminLacksPermission
    end
  end
end
