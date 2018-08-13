module Cadet
  class PaddleWebhooks
    def initialize(params)
      @params = params
    end

    def consume
      return unless valid_webhook_call?

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
        message = "*##{@company.subdomain}* became a paying customer!"
        NotifySlackJob.perform_later(message, channel: "#main")
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

      # Reference: https://paddle.com/docs/reference-verifying-webhooks
      def valid_webhook_call?
        return true if Rails.env.test?

        signature = Base64.decode64(@params['p_signature'])
        @params.delete('p_signature')

        @params.each { |key, value| @params[key] = String(value)}
        data_sorted = @params.sort_by{ |key, value| key }
        data_serialized = PHP.serialize(data_sorted, true)

        digest = OpenSSL::Digest::SHA1.new
        pub_key = OpenSSL::PKey::RSA.new(public_key).public_key
        
        pub_key.verify(digest, signature, data_serialized)
      end

      def public_key
        @public_key ||= File.read("#{Rails.root}/config/paddle_public_key.txt")
      end
  end
end
