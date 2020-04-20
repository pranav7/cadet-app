module Votes
  class Delete < Base
    attr_reader :post, :voter
    
    def validate!
      validate_user_has_permission
    end

    def run!
      Vote.where(post: post, user: voter).first&.destroy!
    end
  end
end
