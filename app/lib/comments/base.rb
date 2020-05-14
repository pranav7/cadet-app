module Comments
  class Base
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

    protected

    def validate_user_has_permission
      return if Current.user.admin_of?(Current.company)
      return unless @is_private && !Current.user.admin_of?(Current.company)
      raise Errors::AdminLacksPermission
    end
  end
end
