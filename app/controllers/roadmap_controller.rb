class RoadmapController < ApplicationController
    def index
      if user_signed_in? && current_user.admin_of?(current_company)
        @roadmap = current_company.roadmap
      else
        # If user is not signed in, the roadmap should not contain
        # any posts from private board
        @roadmap = current_company.public_roadmap
      end
    end
  end
  