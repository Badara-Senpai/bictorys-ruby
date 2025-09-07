# frozen_string_literal: true

module Bictorys
  module Resources
    class Charges
      SUPPORTED_METHODS = %w[orange_money wave_money maxit card].freeze

      def initialize(client) = @client = client

      def create(amount_cents:, currency:, reference:, success_url:, error_url:, payment_method: nil, metadata: {})
        if payment_method && !SUPPORTED_METHODS.include?(payment_method.to_s)
          raise ArgumentError, "Unsupported payment_method: #{payment_method}"
        end

        path   = "/pay/v1/charges"
        params = payment_method ? { payment_type: payment_method.to_s } : nil

        payload = {
          amount:              Integer(amount_cents),
          currency:            currency.to_s.upcase,
          paymentReference:    reference.to_s,
          successRedirectUrl:  success_url.to_s,
          errorRedirectUrl:    error_url.to_s,
          metadata:            metadata || {}
        }

        raw = @client.post(path + (params ? "?payment_type=#{params[:payment_type]}" : ""), payload)

        checkout_url = (raw["link"] || raw["checkout_url"]).to_s
        charge_id    = (raw["transactionId"] || raw["id"]).to_s

        if payment_method.to_s == "card" && checkout_url != ""
          delimiter   = checkout_url.include?("?") ? "&" : "?"
          checkout_url = "#{checkout_url}#{delimiter}payment_category=card"
        end

        {
          checkout_url: checkout_url,
          charge_id:    charge_id,
          raw_response: raw
        }
      end
    end
  end
end