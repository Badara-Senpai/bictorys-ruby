# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bictorys::Resources::Charges do
  before do
    Bictorys.configure do |c|
      c.api_key = "test_key"
      c.environment = :sandbox
    end
  end

  it "creates a charge and returns normalized response" do
    stub_request(:post, "https://api.test.bictorys.com/pay/v1/charges")
      .to_return(
        status: 200,
        body: { link: "https://checkout.fake/123", transactionId: "tx_abc" }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    client = Bictorys::Client.new
    result = client.charges.create(
      amount_cents: 1000,
      currency: "XOF",
      reference: "INV-1",
      success_url: "https://ok",
      error_url: "https://ko"
    )

    expect(result[:checkout_url]).to eq("https://checkout.fake/123")
    expect(result[:charge_id]).to eq("tx_abc")
    expect(result[:raw_response]).to be_a(Hash)
  end

  context "errors" do
    before do
      Bictorys.configure do |c|
        c.api_key = "bad_key"
        c.environment = :sandbox
      end
    end

    it "raises Unauthorized on 401" do
      stub_request(:post, "https://api.test.bictorys.com/pay/v1/charges")
        .to_return(
          status: 401,
          body: { error: "invalid api key" }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      client = Bictorys::Client.new

      expect {
        client.charges.create(
          amount_cents: 1000,
          currency: "XOF",
          reference: "INV-401",
          success_url: "https://ok",
          error_url: "https://ko"
        )
      }.to raise_error(Bictorys::Error::Unauthorized)
    end

    it "raises NetworkError on timeout" do
      stub_request(:post, "https://api.test.bictorys.com/pay/v1/charges").to_timeout

      client = Bictorys::Client.new

      expect {
        client.charges.create(
          amount_cents: 1000,
          currency: "XOF",
          reference: "INV-timeout",
          success_url: "https://ok",
          error_url: "https://ko"
        )
      }.to raise_error(Bictorys::Error::NetworkError)
    end
  end
end