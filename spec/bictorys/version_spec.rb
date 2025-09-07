# frozen_string_literal: true

require "spec_helper"

RSpec.describe Bictorys do
  it "has a version number" do
    expect(Bictorys::VERSION).to be_a(String)
    expect(Bictorys::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end