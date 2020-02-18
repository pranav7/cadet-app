class RoadmapsController < ApplicationController
    def index
      if not current_company.is_cadet_app?
        redirect_to root_path
      end

      if user_signed_in? && current_user.admin_of?(current_company)
        @planned_posts = get_posts(status: Post.statuses[:planned])
        @devloping_posts = get_posts(status: Post.statuses[:developing])
        @released_posts = get_posts(status: Post.statuses[:released])
      else
        # If user is not signed in, the roadmap should not contain
        # any posts from private board
        @planned_posts = get_posts(status: Post.statuses[:planned], public_boards: true)
        @devloping_posts = get_posts(status: Post.statuses[:developing], public_boards: true)
        @released_posts = get_posts(status: Post.statuses[:released], public_boards: true)
      end
    end

    private

    def get_posts(status:, public_boards: false)
      if public_boards        
        Post.latest_activity.joins(:board).where(status: status, boards: { private: false, roadmap_enabled: true })
      else
        Post.latest_activity.joins(:board).where(status: status, boards: { roadmap_enabled: true })
      end
    end
  end
  