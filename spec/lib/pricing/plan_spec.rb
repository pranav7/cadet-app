require 'rails_helper'

describe ::Pricing::Plan do
  let(:version) { nil }
  subject { described_class.new(version: version) }

  it "has the correct number of total plans" do
    expect(subject.config.count).to eq(2)
  end

  context "active version" do
    it "returns the active version by default" do
      expect(subject.version).to eq(described_class::ACTIVE_VERSION)
    end

    it "has the correct pricing figures" do
      expect(subject.name).to eq("base")
      expect(subject.base_price).to eq(49)
      expect(subject.per_user_price).to eq(19)
      expect(subject.per_user_modulus).to eq(100)
      expect(subject.paddle_product_id).to eq(586_321)
    end
  end

  context "version is specified" do
    let(:version) { "v1" }

    it "returns the correct version" do
      expect(subject.version).to eq(version)
    end

    it "has the correct pricing figures" do
      expect(subject.name).to eq("base")
      expect(subject.base_price).to eq(29)
      expect(subject.per_user_price).to eq(9)
      expect(subject.per_user_modulus).to eq(100)
      expect(subject.paddle_product_id).to eq(519_979)
    end
  end
end
