module Pricing
  class Plan
    PLANS_CONFIG = "#{Rails.root}/config/pricing.yml".freeze
    ACTIVE_VERSION = "v1.1".freeze
    TRIAL_PERIOD = 14

    attr_reader :base_price, :per_user_price, :per_user_modulus, :paddle_product_id, :version

    def initialize(version: nil)
      @version = version || ACTIVE_VERSION
      @base_price = plans.base_price
      @per_user_price = plans.per_user_price
      @per_user_modulus = plans.per_user_modulus
      @paddle_product_id = plans.paddle_product_id
    end

    private def plans
      @plans ||= config[@version]
    end

    private def config
      @config ||= Hashie::Mash.new(YAML.safe_load(File.read(PLANS_CONFIG)))
    end

  end
end
