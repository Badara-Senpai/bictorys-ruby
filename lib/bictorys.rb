# frozen_string_literal: true

require_relative "bictorys/version"
require_relative "bictorys/config"
require_relative "bictorys/client"
require_relative "bictorys/error"
require_relative "bictorys/resources/charges"
require_relative "bictorys/webhooks"

module Bictorys
  # Configuration DSL
  def self.configure
    yield(Config)
  end
end