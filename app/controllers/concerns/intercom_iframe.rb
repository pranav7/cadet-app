module IntercomIframe
  extend ActiveSupport::Concern

  included do
    skip_after_action :intercom_rails_auto_include

    before_action do
      session[:hide_public_header] = true if params[:intercom_iframe]
    end

    after_action do
      response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM https://intercom-sheets.com"
    end
  end
end
