# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONSkooma::Sources::Local do
  subject(:local_source) { described_class.new(base, suffix: suffix) }

  let(:base) { File.expand_path(File.join(__dir__, "..", "..", "fixtures")) }
  let(:suffix) { ".json" }

  describe "#call" do
    context "when json file exists" do
      let(:relative_path) { "key_value" }

      it "returns parsed content of the file" do
        expect(local_source.call(relative_path)).to eq({"key" => "value"})
      end
    end

    context "when yaml file exists" do
      let(:relative_path) { "key_value" }
      let(:suffix) { ".yml" }

      it "returns parsed content of the file" do
        expect(local_source.call(relative_path)).to eq({"key" => "value"})
      end
    end

    context "when file does not exist" do
      let(:relative_path) { "non_existent_file" }

      it "raises an error" do
        expect { local_source.call(relative_path) }.to raise_error(JSONSkooma::Sources::Error)
      end
    end
  end
end
