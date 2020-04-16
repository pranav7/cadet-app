# lib/posts/update.rb
module Post
  class Update
    attr_reader :post, :voter

    def self.run(post:, params: params) 
      new(post: post, params: params).run
    end

    def initialize(post:)
      @post = post
      @params = params
    end

    def validate!
      unless Current.user.admin_of?(Current.company)
        raise AdminLacksPermission.new("Admin does not have permission")
      end

      raise StandardServiceError.new("title can't be empty") unless @title.present?
    end

    def run
      ActiveRecord::Base.transaction do
        log_activity if post_status_changed?
        @post.assign_attributes(params)
        add_voter if @post.user_id_changed?
      end
    end

    private

    def log_activity
      ActivityLog.create(
        post: post,
        company: post.company,
        old_value: post.status
        new_value: params[:status]
        visibility: ActivityLog::PUBLIC
      )
    end

    def post_status_changed?
      return false unless params[:status]
      params[:status] != post.status
    end

    def add_voter
      requester = User.find(post_params[:user_id])
      @post.votes.build(user: requester, added_by: current_user)
    end
  end
end
