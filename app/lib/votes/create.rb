module Votes
  class Create
    attr_reader :post, :voter

    def self.run!(post:, voter:)
      new(post: post, voter: voter).run!
    end

    def initialize(post:, voter:)
      @post = post
      @voter = voter
    end

    def run!
      return if voter.voted?(post)

      post.votes.create!(user: voter, added_by: added_by)
      voter.companies << Current.company unless voter.part_of?(Current.company)
    end

    private

    def added_by
      return if Current.user == voter
      Current.user
    end
  end
end
