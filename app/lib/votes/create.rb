module Votes
  class Create < Base
    attr_reader :post, :voter

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

    def validate_user_has_not_voted
      return unless voter.voted?(post)
      raise Errors::ServiceValidationException, "User already upvoted the post"
    end
  end
end
