# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONSkooma::Sources::Remote do
  subject(:remote_source) { described_class.new(base, suffix: suffix) }

  let(:base) { "http://example.com/" }
  let(:suffix) { ".yml" }
  let(:relative_path) { "test" }

  describe "#call" do
    context "when the remote file exists and is valid yaml" do
      before do
        stub_request(:get, "#{base}#{relative_path}#{suffix}")
          .to_return(body: "---\nkey: value\n")
      end

      it "returns the parsed YAML content" do
        expect(remote_source.call(relative_path)).to eq({"key" => "value"})
      end
    end

    context "when the remote file exists and is valid json" do
      let(:suffix) { ".json" }

      before do
        stub_request(:get, "#{base}#{relative_path}#{suffix}")
          .to_return(body: "{\"key\":\"value\"}")
      end

      it "returns the parsed JSON content" do
        expect(remote_source.call(relative_path)).to eq({"key" => "value"})
      end
    end

    context "when the remote file does not exist" do
      before do
        stub_request(:get, "#{base}#{relative_path}#{suffix}")
          .to_return(status: 404)
      end

      it "raises an error" do
        expect { remote_source.call(relative_path) }.to raise_error(JSONSkooma::Sources::Error)
      end
    end

    context "when the remote file is not valid YAML" do
      before do
        stub_request(:get, "#{base}#{relative_path}#{suffix}")
          .to_return(body: "not: valid: yaml:")
      end

      it "raises an error" do
        expect { remote_source.call(relative_path) }.to raise_error(JSONSkooma::Sources::Error)
      end
    end
  end
end
