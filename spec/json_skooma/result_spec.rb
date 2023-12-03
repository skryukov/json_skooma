# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONSkooma::Result do
  subject(:result) { schema.evaluate(instance) }

  let(:schema) do
    JSONSkooma::JSONSchema.new(
      {
        "$schema" => "https://json-schema.org/draft/2020-12/schema",
        "$id" => "https://json.skooma/test/character-sheet",
        "type" => "object",
        "properties" => {
          "name" => {"type" => "string"},
          "race" => {"enum" => %w[Nord Khajiit Argonian Breton Redguard Dunmer Altmer Bosmer Orc Imperial]},
          "class" => {"type" => "string"},
          "level" => {"type" => "integer", "minimum" => 1},
          "equipment" => {
            "type" => "array",
            "items" => {"type" => "string"}
          }
        },
        "required" => %w[name race class level]
      }
    )
  end
  let(:instance) do
    {
      name: "Matz",
      race: "Human",
      class: "Dragonborn",
      level: 50,
      equipment: %w[Ruby]
    }
  end

  describe ".output" do
    subject(:output) { result.output(format) }

    let(:format) { :flag }

    let(:expected_output) { {"valid" => false} }

    it { is_expected.to eq(expected_output) }

    context "with :basic format" do
      let(:format) { :basic }

      let(:expected_output) do
        {
          "valid" => false,
          "errors" => [
            {
              "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties",
              "keywordLocation" => "/properties",
              "instanceLocation" => "",
              "error" => "Properties race are invalid"
            },
            {
              "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/race/enum",
              "keywordLocation" => "/properties/race/enum",
              "instanceLocation" => "/race",
              "error" => "The instance value Human must be equal to one of the elements in the defined enumeration: Nord, Khajiit, Argonian, Breton, Redguard, Dunmer, Altmer, Bosmer, Orc, Imperial"
            }
          ]
        }
      end

      it { is_expected.to eq(expected_output) }
    end

    context "with :detailed format" do
      let(:format) { :detailed }

      let(:expected_output) do
        {
          "valid" => false,
          "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#",
          "keywordLocation" => "",
          "instanceLocation" => "",
          "errors" => [
            {
              "valid" => false,
              "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/race/enum",
              "keywordLocation" => "/properties/race/enum",
              "instanceLocation" => "/race",
              "error" => "The instance value Human must be equal to one of the elements in the defined enumeration: Nord, Khajiit, Argonian, Breton, Redguard, Dunmer, Altmer, Bosmer, Orc, Imperial"
            }
          ]
        }
      end

      it { is_expected.to eq(expected_output) }
    end

    context "with :verbose format" do
      let(:format) { :verbose }

      let(:expected_output) do
        {
          "valid" => false,
          "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#",
          "keywordLocation" => "",
          "instanceLocation" => "",
          "errors" => [
            {
              "valid" => true,
              "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/type",
              "keywordLocation" => "/type",
              "instanceLocation" => ""
            },
            {
              "valid" => false,
              "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties",
              "keywordLocation" => "/properties",
              "instanceLocation" => "",
              "error" => "Properties race are invalid",
              "errors" => [
                {
                  "valid" => true,
                  "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/name",
                  "keywordLocation" => "/properties/name",
                  "instanceLocation" => "/name",
                  "annotations" => [
                    {
                      "valid" => true,
                      "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/name/type",
                      "keywordLocation" => "/properties/name/type",
                      "instanceLocation" => "/name"
                    }
                  ]
                },
                {
                  "valid" => false,
                  "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/race",
                  "keywordLocation" => "/properties/race",
                  "instanceLocation" => "/race",
                  "errors" => [
                    {
                      "valid" => false,
                      "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/race/enum",
                      "keywordLocation" => "/properties/race/enum",
                      "instanceLocation" => "/race",
                      "error" => "The instance value Human must be equal to one of the elements in the defined enumeration: Nord, Khajiit, Argonian, Breton, Redguard, Dunmer, Altmer, Bosmer, Orc, Imperial"
                    }
                  ]
                },
                {
                  "valid" => true,
                  "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/class",
                  "keywordLocation" => "/properties/class",
                  "instanceLocation" => "/class",
                  "annotations" => [
                    {
                      "valid" => true,
                      "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/class/type",
                      "keywordLocation" => "/properties/class/type",
                      "instanceLocation" => "/class"
                    }
                  ]
                },
                {
                  "valid" => true,
                  "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/level",
                  "keywordLocation" => "/properties/level",
                  "instanceLocation" => "/level",
                  "annotations" => [
                    {
                      "valid" => true,
                      "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/level/type",
                      "keywordLocation" => "/properties/level/type",
                      "instanceLocation" => "/level"
                    },
                    {
                      "valid" => true,
                      "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/level/minimum",
                      "keywordLocation" => "/properties/level/minimum",
                      "instanceLocation" => "/level"
                    }
                  ]
                },
                {
                  "valid" => true,
                  "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/equipment",
                  "keywordLocation" => "/properties/equipment",
                  "instanceLocation" => "/equipment",
                  "annotations" => [
                    {
                      "valid" => true,
                      "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/equipment/type",
                      "keywordLocation" => "/properties/equipment/type",
                      "instanceLocation" => "/equipment"
                    },
                    {
                      "valid" => true,
                      "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/equipment/items",
                      "keywordLocation" => "/properties/equipment/items",
                      "instanceLocation" => "/equipment",
                      "annotation" => true,
                      "annotations" => [
                        {
                          "valid" => true,
                          "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/properties/equipment/items/type",
                          "keywordLocation" => "/properties/equipment/items/type",
                          "instanceLocation" => "/equipment/0"
                        }
                      ]
                    }
                  ]
                }
              ]
            },
            {
              "valid" => true,
              "absoluteKeywordLocation" => "https://json.skooma/test/character-sheet#/required",
              "keywordLocation" => "/required",
              "instanceLocation" => ""
            }
          ]
        }
      end

      it { is_expected.to eq(expected_output) }
    end
  end
end
