# frozen_string_literal: true

require "spec_helper"
require "json"

RSpec.shared_context "json_schema_test_suite" do |suite|
  suite.each do |file|
    JSON.parse(File.read(file)).each do |test_case|
      context test_case["description"] do
        test_case["tests"].each do |test|
          it test["description"] do
            schema = JSONSkooma::JSONSchema.new(test_case["schema"], metaschema_uri: metaschema_uri)
            result = schema.evaluate(test["data"])

            expect(result.valid?).to eq(test["valid"]), "Expected #{test["data"]} to be #{test["valid"] ? "valid" : "invalid"}"
          end
        end
      end
    end
  end
end

RSpec.describe JSONSkooma do
  let(:metaschema_uri) { "https://json-schema.org/draft/2020-12/schema" }

  Dir["#{File.expand_path("../json_schema_test_suite/tests", __FILE__)}/*"].each do |suite|
    version = File.basename(suite)
    next unless version == "draft2020-12" || version == "draft2019-09"

    context version do
      context "required assertions", version: version do
        before(:all) do
          registry = JSONSkooma.create_registry(version[5..], "2020-12")
          remotes = File.join(__dir__, "json_schema_test_suite", "remotes")
          registry.add_source(
            "http://localhost:1234/",
            JSONSkooma::Sources::Local.new(remotes.to_s)
          )
        end

        include_context "json_schema_test_suite", Dir["#{suite}/*.json"]
      end

      context "optional assertions" do
        before(:all) do
          registry = JSONSkooma.create_registry("2020-12", "2019-09", assert_formats: true)
          remotes = File.join(__dir__, "json_schema_test_suite", "remotes")
          registry.add_source(
            "http://localhost:1234/",
            JSONSkooma::Sources::Local.new(remotes.to_s)
          )
        end

        include_context "json_schema_test_suite", (Dir["#{suite}/optional/*.json"].reject do |file|
          [
            "dependencies-compatibility.json",
            "ecmascript-regex.json",
            "refOfUnknownKeyword.json"
          ].include?(file.split("/").last) ||
            version == "draft2019-09" &&
              [
                "cross-draft.json"
              ].include?(file.split("/").last)
        end)
      end

      context "format assertions" do
        before(:all) do
          JSONSkooma.create_registry(version[5..], assert_formats: true)
        end

        include_context "json_schema_test_suite", Dir["#{suite}/optional/format/*.json"]
      end
    end
  end
end
