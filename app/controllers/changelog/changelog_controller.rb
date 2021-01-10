class Changelog::ChangelogController < ApplicationController
    def index
        @posts = ChangelogPost.all.order(created_at: :desc)
    end
end
