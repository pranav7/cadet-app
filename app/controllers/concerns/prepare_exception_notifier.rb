module PrepareExceptionNotifier
  extend ActiveSupport::Concern

  included do
    before_action :prepare_exception_notifier
  end

  private
    def prepare_exception_notifier
      exception_data = {
        url: request.url,
        ip: request.ip
      }
      exception_data[:current_user] = current_user.serializable_hash if user_signed_in?

      request.env["exception_notifier.exception_data"] = exception_data
    end
end
