# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONSkooma::JSONSchema do
  before(:all) { JSONSkooma.create_registry("2020-12", assert_formats: true) }

  describe "#evaluate" do
    subject(:evaluate) { schema.evaluate(instance, ref: ref) }

    let(:schema) { JSONSkooma::JSONSchema.new(schema_data) }
    let(:instance) { {foo: "bar"} }
    let(:ref) { nil }

    let(:schema_data) do
      {
        "$schema" => "https://json-schema.org/draft/2020-12/schema",
        "type" => "object",
        "properties" => {
          "foo" => {
            "type" => "string"
          }
        },
        "$defs" => {
          "FooBaz" => {
            "type" => "object",
            "properties" => {
              "foo" => {
                "type" => "string",
                "enum" => ["baz"]
              }
            }
          }
        }
      }
    end

    it { is_expected.to be_valid }

    context "with required keys" do
      before do
        schema_data["required"] = %w[foo bar]
        schema_data["properties"]["bar"] = {"type" => "integer"}
      end

      it { is_expected.not_to be_valid }

      it "informs us which key is missing" do
        errors = subject.output(:detailed)["errors"].map { |e| e["error"] }

        expect(errors).to contain_exactly(
          "The object requires the following keys: foo, bar. Missing keys: bar"
        )
      end

      context "with valid instance" do
        let(:instance) { {foo: "baz", bar: 123} }

        it { is_expected.to be_valid }
      end
    end

    context "with ref option" do
      let(:ref) { "#/$defs/FooBaz" }

      it { is_expected.not_to be_valid }

      context "with valid instance" do
        let(:instance) { {foo: "baz"} }

        it { is_expected.to be_valid }
      end

      context "with invalid ref" do
        let(:ref) { "#/$defs/BarBaz" }

        it "raises an error" do
          expect { evaluate }.to raise_error(JSONSkooma::Error, /BarBaz/)
        end
      end
    end
  end
end
