# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bictorys::Client do
  it "builds and exposes the charges resource" do
    client = described_class.new(api_key: "test", environment: :sandbox)
    charges = client.charges
    expect(charges).to be_a(Bictorys::Resources::Charges)
  end
end