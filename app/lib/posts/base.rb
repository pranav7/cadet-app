module Posts
  class Base
    def self.run!(post:, title:, status:, requester_id:, content:)
      service = new(post: post, title: title, status: status, requester_id: requester_id, content: content)
      service.validate!
      service.run!
    end

    def initialize(post:, title:, status:, requester_id:, content:)
      @post = post
      @title = title
      @status = status
      @requester_id = requester_id
      @content = content
    end

    protected

    def validate_user_has_permission
      return if Current.user.admin_of?(Current.company)
      raise Errors::AdminLacksPermission
    end
  end
end
