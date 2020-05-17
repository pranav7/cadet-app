module Pricing
  class Plan
    PLANS_CONFIG = "#{Rails.root}/config/pricing.yml".freeze
    ACTIVE_VERSION = "v1.1".freeze
    TRIAL_PERIOD = 14

    attr_reader :name, :base_price, :per_user_price, :per_user_modulus, :paddle_product_id, :version

    def initialize(version: nil)
      @version = version || ACTIVE_VERSION
      @name = plan.name
      @base_price = plan.base_price
      @per_user_price = plan.per_user_price
      @per_user_modulus = plan.per_user_modulus
      @paddle_product_id = plan.paddle_product_id
    end

    def config
      @config ||= Hashie::Mash.new(YAML.safe_load(File.read(PLANS_CONFIG)))
    end

    private

    def plan
      @plan ||= config[@version]
    end
  end
end
