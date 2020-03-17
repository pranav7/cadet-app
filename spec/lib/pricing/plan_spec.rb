require 'rails_helper'

describe ::Pricing::Plan do
  let(:version) { nil }
  subject { described_class.new(version: version) }

  context "no version is specified" do
    it "returns the active version by default" do
      expect(subject.version).to eq(described_class::ACTIVE_VERSION)
    end
  end

  context "version is specified" do
    let(:version) { "v1" }

    it "returns the correct version" do
      expect(subject.version).to eq(version)
    end
  end
end
