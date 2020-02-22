class RoadmapsController < ApplicationController
  before_action :verify_feature_access

  def index
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
      Post.latest_activity.joins(:board).where(status: status, boards: { private: false, roadmap_enabled: true, company_id: current_company.id })
    else
      Post.latest_activity.joins(:board).where(status: status, boards: { roadmap_enabled: true, company_id: current_company.id })
    end
  end

  def verify_feature_access
    redirect_to(root_path) unless can_access_feature?
  end
end
