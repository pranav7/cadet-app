class Changelog::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize!
  
    def show
        
    end

    def new
        @post = ChangelogPost.new
    end

    def create
        @post = ChangelogPost.new(post_params)
        @post.subdomain = current_company.subdomain

        if @post.save
            redirect_to changelog_url
        else
            render :new
        end
    end

    def edit
        @post = ChangelogPost.find(params[:id])
    end

    def update
        @post = ChangelogPost.find(params[:id])
    
        if @post.update(post_params)
          redirect_to changelog_url
        else
          render :edit
        end
    end

    def destroy
        @post = ChangelogPost.find(params[:id])
        @post.destroy
    
        redirect_to changelog_url
    end    
    

    private
    def post_params
      params.require(:changelog_post).permit(:title, :status, :content)
    end

    def authorize!
        return redirect_to(changelog_url) unless current_user.admin_of?(current_company)
    end
    
end
