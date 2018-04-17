module Cadet
  class PaddleWebhooks
    def initialize(params)
      @params = params
    end

    def consume
      case event
      when "subscription_created"
        handle_subscription_created
        notify_slack
      end
    end

    private
      def handle_subscription_created
        company_setting = company.company_setting
        company_setting.billing_plan = "basic"
        company_setting.expires_at = nil
        company_setting.paddle_subscription_id = @params["subscription_id"]
        company_setting.save
      end

      def notify_slack
      end

      def event
        @params["alert_name"]
      end

      def passthrough
        Hashie::Mash.new JSON.parse(@params["passthrough"])
      end

      def company
        @company ||= Company.find_by(subdomain: passthrough.company_subdomain)
      end
  end
end
