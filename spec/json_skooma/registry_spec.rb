# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONSkooma::Registry do
  subject(:registry) { JSONSkooma.create_registry("2020-12", name: "registry_spec_#{SecureRandom.hex(4)}") }

  let(:fixtures_dir) { File.expand_path("../fixtures", __dir__) }

  describe "#load_json" do
    it "returns parsed content from a registered source" do
      registry.add_source("https://example.com/", JSONSkooma::Sources::Local.new(fixtures_dir, suffix: ".json"))

      expect(registry.load_json(URI.parse("https://example.com/key_value")))
        .to eq({"key" => "value"})
    end

    it "raises when no source matches the uri" do
      expect { registry.load_json(URI.parse("https://example.com/anything")) }
        .to raise_error(JSONSkooma::RegistryError, /source is not available/)
    end
  end

  describe "#schema" do
    it "raises UnexpectedSchemaClassError when the fragment is not the expected class" do
      registry.add_source("https://example.com/", JSONSkooma::Sources::Local.new(fixtures_dir, suffix: ".json"))

      metaschema_uri = URI.parse("https://json-schema.org/draft/2020-12/schema")
      uri = URI.parse("https://example.com/key_value#/key")

      expect { registry.schema(uri, metaschema_uri: metaschema_uri, expected_class: JSONSkooma::JSONSchema) }
        .to raise_error(JSONSkooma::UnexpectedSchemaClassError) { |error|
          expect(error.uri.to_s).to eq(uri.to_s)
          expect(error.expected_class).to eq(JSONSkooma::JSONSchema)
        }
    end

    it "UnexpectedSchemaClassError is a RegistryError (back-compat)" do
      expect(JSONSkooma::UnexpectedSchemaClassError.ancestors)
        .to include(JSONSkooma::RegistryError)
    end
  end
end

RSpec.describe JSONSkooma::Keywords::ValueSchemas do
  before(:all) do
    JSONSkooma.create_registry("2020-12", name: "value_schemas_spec") unless JSONSkooma::Registry.registries.key?("value_schemas_spec")
  end

  around do |example|
    original = described_class.default_schema_class
    example.run
  ensure
    described_class.default_schema_class = original
  end

  it "defaults to JSONSchema" do
    described_class.instance_variable_set(:@default_schema_class, nil)
    expect(described_class.default_schema_class).to eq(JSONSkooma::JSONSchema)
  end

  it "accepts a custom default class used when a keyword has no schema_value_class" do
    custom_class = Class.new(JSONSkooma::JSONSchema)
    described_class.default_schema_class = custom_class

    schema = JSONSkooma::JSONSchema.new(
      {"$schema" => "https://json-schema.org/draft/2020-12/schema", "items" => {"type" => "string"}},
      registry: "value_schemas_spec"
    )
    expect(schema["items"]).to be_a(custom_class)
  end
end
