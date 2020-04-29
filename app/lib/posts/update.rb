module Posts
  class Update < Base
    attr_reader :post, :title, :status, :requester_id, :content

    def validate!
      validate_user_has_permission
    end

    def run!
      update_post
    end

    private

    def update_post
      @post.title = @title if @title
      if @status
        log_activity
        @post.status = @status
      end
      if @requester_id && @requester_id != @post.user_id
        @post.user_id = @requester_id
        add_voter
      end
      @post.content.body = @content["body"] if @content && @content["body"]
      @post.slug = nil if @post.title_changed?

      @post.save!
    end

    def log_activity
      return if @post.status == @status
      ActiveRecord::Base.transaction do
        event = StatusChangedEvent.create(
          post_id: @post.id,
          company: @post.company,
          old_value: Post.statuses[@post.status],
          new_value: @status,
          admin_id: Current.user.id,
          company_id: @post.company.id
        )
        ActivityLog.create(
          event_type: Constants::EventTypes::STATUS_CHANGED,
          event_id: event.id,
          company_id: @post.company.id,
          visibility: Constants::Visibility::PUBLIC,
          post_id: @post.id
        )
      end
    end

    def add_voter
      voter = User.find(@requester_id)
      Votes::Create.run!(post: @post, voter: voter)
    end
  end
end
