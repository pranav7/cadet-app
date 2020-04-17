module Votes
  class Create
    attr_reader :post, :voter

    def self.run!(post:, voter:)
      service = new(post: post, voter: voter)
      service.validate!
      service.run!
    end

    def initialize(post:, voter:)
      @post = post
      @voter = voter
    end

    def validate!
      validate_user_has_permission
      validate_user_has_not_voted
    end

    def run!
      post.votes.create(user: voter, added_by: added_by)
      voter.companies << Current.company unless voter.part_of?(Current.company)
    end

    private

    def added_by
      return if Current.user == voter
      Current.user
    end

    def validate_user_has_permission
      return if Current.user == voter
      return if Current.user.admin_of?(Current.company)
      raise Errors::AdminLacksPermission
    end

    def validate_user_has_not_voted
      return unless voter.voted?(post)
      raise Errors::ServiceValidationError, "User already upvoted the post"
    end
  end
end
