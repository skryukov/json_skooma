# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONSkooma::JSONNode do
  subject(:node) { described_class.new(value) }

  let(:value) { {a: {b: {c: [1, 2], d: "foo", e: nil}}} }

  describe "#path" do
    subject { node.path }

    it { is_expected.to eq JSONSkooma::JSONPointer.new "" }

    context "when node has parent" do
      let(:node) { super()["a"] }

      it { is_expected.to eq JSONSkooma::JSONPointer.new "/a" }
    end

    context "when node has array parent" do
      let(:node) { super()["a"]["b"]["c"]["1"] }

      it { is_expected.to eq JSONSkooma::JSONPointer.new "/a/b/c/1" }
    end
  end
end
