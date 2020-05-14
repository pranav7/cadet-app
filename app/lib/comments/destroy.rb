module Comments
  class Destroy
    attr_reader :comment

    def self.run!(comment:)
      service = new(comment: comment)
      service.validate!
      service.run!
    end

    def initialize(comment:)
      @comment = comment
    end

    def validate!
      validate_user_can_delete
    end

    def run!
      ActiveRecord::Base.transaction do
        comment.comment_created_event.activity_log.destroy!
        comment.comment_created_event.destroy!
        comment.destroy!
      end
    end

    private

    def validate_user_can_delete
      return if Current.user == comment.commenter
      raise Errors::AdminLacksPermission
    end
  end
end
