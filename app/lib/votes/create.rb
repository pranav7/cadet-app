module Votes
  class Create
    attr_reader :post, :voter

    def self.run(post:, voter:)
      new(post: post, voter: voter).run
    end

    def initialize(post:, voter:)
      @post = post
      @voter = voter
    end

    def valid?
      return false if voter.voted?(post)
      return false unless user_has_permission?
      true
    end

    def run
      create_vote if valid?
    end

    private

    def create_vote
      post.votes.create(user: voter, added_by: added_by)
      voter.companies << Current.company unless voter.part_of?(Current.company)
    end

    def added_by
      return if Current.user == voter
      Current.user
    end

    def user_has_permission?
      return true if Current.user == voter
      Current.user.admin_of?(Current.company)
    end
  end
end
