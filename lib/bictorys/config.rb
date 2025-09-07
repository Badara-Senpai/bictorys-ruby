# frozen_string_literal: true

module Bictorys
  module Config
    class << self
      attr_accessor :api_key, :environment, :base_url, :timeout, :open_timeout, :logger
    end
    # Defaults (actual URLs to set later)
    self.environment  = :sandbox
    self.base_url     = nil   # when nil, client decides from environment
    self.timeout      = 15
    self.open_timeout = 5
    self.logger       = nil
  end
end