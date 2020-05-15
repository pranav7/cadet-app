class Admin::ActivityLogsController < Admin::AdminController
  def index
    @activity_log = @post.activity_logs
  end
end
