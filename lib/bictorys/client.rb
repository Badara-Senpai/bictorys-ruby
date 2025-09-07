# frozen_string_literal: true

module Bictorys
  class Client
    def initialize(**opts)
      @api_key       = opts[:api_key]       || Config.api_key
      @environment   = opts[:environment]   || Config.environment
      @base_url      = opts[:base_url]      || Config.base_url
      @timeout       = opts[:timeout]       || Config.timeout
      @open_timeout  = opts[:open_timeout]  || Config.open_timeout
      @logger        = opts[:logger]        || Config.logger
    end

    def charges
      Resources::Charges.new(self)
    end
  end
end