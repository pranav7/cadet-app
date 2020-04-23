module Posts
  class Update
    attr_reader :post, :params

    def self.run!(post:, title:, status:, user_id:, content:)
      service = new(post: post, title: title, status: status, user_id: user_id, content: content)
      service.validate!
      service.run!
    end

    def initialize(post:, title:, status:, user_id:, content:)
      @post = post
      @title = title
      @status = status
      @user_id = user_id
      @content = content
    end

    def validate!
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
      @post.user_id = @user_id if @user_id
      @post.content.body = @content["body"] if @content && @content["body"]
      @post.slug = nil if @post.title_changed?

      @post.save!
    end

    def log_activity
      ActiveRecord::Base.transaction do
        event = StatusChangedEvent.create(
          post_id: @post.id,
          company: @post.company,
          old_value: @post.status,
          new_value: @status,
          admin_id: Current.user.id,
          company_id: @post.company.id
        )
        ActivityLog.create(
          event_type: Constants::EventTypes::STATUS_CHANGED,
          event_id: event.id,
          company_id: @post.company.id,
          visibility: Constants::VisibilityTypes::PUBLIC,
          post_id: @post.id
        )
      end
    end

    def add_voter
      voter = find_voter
      Votes::Create.run(post: @post, voter: voter)
    end

    def find_voter
      return User.find(params[:user_id]) if params[:user_id]
      Current.user
    end
  end
end