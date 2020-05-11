module Comments
  class Destroy
    attr_reader :comment

    def self.run!(comment:)
      service = new(comment: comment).run!
      service.validate!
    end

    def initialize(comment:)
      @comment = comment
    end

    def validate!
      validate_user_has_permission
    end

    def run!
      ActiveRecord::Base.transaction do
        comment.comment_created_event.activity_log.destroy!
        comment.comment_created_event.destroy!
        comment.destroy!
      end
    end

    private

    def validate_user_has_permission
      return Current.user == comment.commenter
      raise Errors::AdminLacksPermission
    end
  end
end
