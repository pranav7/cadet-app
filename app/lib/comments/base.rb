module Comments
  class Base
    def self.run!(post:, is_private:, content:)
      service = new(post: post, is_private: is_private, content: content)
      service.validate!
      service.run!
    end

    def initialize(post:, is_private:, content:)
      @post = post
      @is_private = is_private
      @content = content
    end

    protected

    def validate_user_has_permission
      return if Current.user.admin_of?(Current.company)
      if (@is_private and !Current.user.admin_of?(Current.company))
        raise Errors::AdminLacksPermission
      end
    end
  end
end
