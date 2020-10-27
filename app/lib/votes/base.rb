module Votes
  class Base
    def self.run!(post:, voter:)
      service = new(post: post, voter: voter)
      service.validate!
      service.run!
    end

    def initialize(post:, voter:)
      @post = post
      @voter = voter
    end

    protected

    def validate_user_has_permission
      return if Current.user == voter
      return if Current.user.admin_of?(Current.company)

      raise Errors::AdminLacksPermission
    end
  end
end
