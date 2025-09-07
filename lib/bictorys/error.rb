# frozen_string_literal: true

module Bictorys
  module Error
    class Base < StandardError
      attr_reader :data
      def initialize(message = nil, data = nil); super(message); @data = data; end
    end
    class NetworkError  < Base; end
    class APIError      < Base; end
    class BadRequest    < Base; end
    class Unauthorized  < Base; end
    class NotFound      < Base; end
    class Conflict      < Base; end
    class Unprocessable < Base; end
  end
end