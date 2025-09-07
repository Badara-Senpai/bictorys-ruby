# frozen_string_literal: true

# frozen_string_literal: true
require "faraday"
require "faraday/retry"
require "json"

module Bictorys
  class Client
    def initialize(**opts)
      @api_key       = opts[:api_key]       || Config.api_key
      @environment   = (opts[:environment]  || Config.environment)&.to_sym
      @base_url      = opts[:base_url]      || Config.base_url || default_base_url
      @timeout       = opts[:timeout]       || Config.timeout
      @open_timeout  = opts[:open_timeout]  || Config.open_timeout
      @logger        = opts[:logger]        || Config.logger

      @conn = Faraday.new(url: @base_url) do |f|
        f.request  :json
        f.request  :retry, max: 3, interval: 0.2, backoff_factor: 2,
                   methods: %i[get post delete put patch]
        f.response :json, content_type: /\bjson$/
        f.adapter  Faraday.default_adapter
      end
    end

    # Resources
    def charges = Resources::Charges.new(self)

    # Low-level HTTP
    def get(path, params = {})  = execute(:get,  path, nil, params)
    def post(path, body = {})    = execute(:post, path, body, nil)

    private

    def default_base_url
      case @environment
      when :live, :production then "https://api.bictorys.com"
      else
        "https://api.test.bictorys.com"
      end
    end

    def execute(verb, path, body, params)
      response = @conn.public_send(verb) do |req|
        req.url(path, params || {})
        req.options.timeout      = @timeout
        req.options.open_timeout = @open_timeout
        req.headers["Accept"]       = "application/json"
        req.headers["Content-Type"] = "application/json"

        req.headers["X-API-Key"]    = @api_key if @api_key
        req.body = body if body
      end
      handle_response(response)
    rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
      raise Error::NetworkError, e.message
    end

    def handle_response(resp)
      status = resp.status.to_i
      body   = resp.body

      case status
      when 200..299 then body
      when 400 then raise Error::BadRequest, body
      when 401 then raise Error::Unauthorized, body
      when 404 then raise Error::NotFound, body
      when 409 then raise Error::Conflict, body
      when 422 then raise Error::Unprocessable, body
      else
        raise Error::APIError.new("HTTP #{status}", body)
      end
    end
  end
end