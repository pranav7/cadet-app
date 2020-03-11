module IntercomIframe
  extend ActiveSupport::Concern

  included do
    skip_after_action :intercom_rails_auto_include

    after_action do
      response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://intercom-sheets.com"
    end
  end
end
