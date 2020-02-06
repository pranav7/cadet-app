class RoadmapController < ApplicationController
    def index
      if user_signed_in? && current_user.admin_of?(current_company)
        @roadmap = current_company.roadmap
      else
        @roadmap = current_company.roadmap
      end

      # statuses = ["open", "planned", "developing", "released", "closed"]
      # @roadmap_posts = []
      # @planned_posts = @boards.first.posts.planned

      # statuses.each do |status|
      #   status_bucket = {
      #       'status' => status,
      #       'posts' => 
      #   }
      #   puts "Status -> ",status
      #   @boards.each do |board|
      #     x = eval("board.posts.#{status}")
      #     status_bucket['posts'] << x
      #   end
      #   @roadmap_posts << status_bucket
      #   puts '==================='
      #   puts status_bucket
      # end         
      # puts '------------------'
      # puts @roadmap_posts
    end
  
    def show
      @board = current_company.boards.friendly.find(params[:id])
      authorize_admin_access! if @board.private?
  
      @post = @board.posts.new
      @post.build_content
      @page_title = "#{@board.name} - #{current_company.name}"
    end
  end
  