class Admin::ActivityLogsController < Admin::AdminController
  def index
    @activity_log = @post.activity_log
  end
end
