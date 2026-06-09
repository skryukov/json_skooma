# frozen_string_literal: true

require "spec_helper"

RSpec.describe JSONSkooma::Formatters::Annotated do
  before(:all) do
    JSONSkooma.create_registry("2020-12", name: "annotated_spec") unless JSONSkooma::Registry.registries.key?("annotated_spec")
  end

  def build_schema(doc)
    JSONSkooma::JSONSchema.new(
      doc.merge("$schema" => "https://json-schema.org/draft/2020-12/schema"),
      registry: "annotated_spec"
    )
  end

  describe "the worked example from skryukov/json_skooma#13" do
    let(:schema) do
      build_schema(
        "type" => "object",
        "properties" => {
          "user_id" => {
            "type" => "integer",
            "title" => "User Identifier",
            "description" => "A unique numeric ID for the user."
          },
          "status" => {
            "type" => "string",
            "title" => "Account Status",
            "description" => "Current state of the user account.",
            "default" => "active"
          },
          "address" => {
            "type" => "object",
            "title" => "Address",
            "description" => "The home address of the person.",
            "properties" => {
              "street" => {
                "type" => "string",
                "title" => "Street Address",
                "description" => "The street address of the person."
              },
              "city" => {
                "type" => "string",
                "title" => "City",
                "description" => "The city where the person lives."
              },
              "state" => {
                "type" => "string",
                "title" => "State",
                "description" => "The state where the person lives."
              },
              "zip" => {
                "type" => "string",
                "title" => "Zip Code",
                "description" => "The zip code of the person's address."
              }
            }
          }
        }
      )
    end

    let(:data) do
      {
        "status" => "pending",
        "user_id" => 123,
        "address" => {
          "street" => "123 Main St",
          "city" => "Anytown",
          "state" => "CA",
          "zip" => "12345"
        }
      }
    end

    it "interleaves the data with title/description annotations" do
      expect(schema.evaluate(data).output(:annotated)).to eq(
        "status" => {
          "title" => "Account Status",
          "description" => "Current state of the user account.",
          "value" => "pending"
        },
        "user_id" => {
          "title" => "User Identifier",
          "description" => "A unique numeric ID for the user.",
          "value" => 123
        },
        "address" => {
          "title" => "Address",
          "description" => "The home address of the person.",
          "value" => {
            "street" => {
              "title" => "Street Address",
              "description" => "The street address of the person.",
              "value" => "123 Main St"
            },
            "city" => {
              "title" => "City",
              "description" => "The city where the person lives.",
              "value" => "Anytown"
            },
            "state" => {
              "title" => "State",
              "description" => "The state where the person lives.",
              "value" => "CA"
            },
            "zip" => {
              "title" => "Zip Code",
              "description" => "The zip code of the person's address.",
              "value" => "12345"
            }
          }
        }
      )
    end

    it "includes additional annotation keywords when requested" do
      output = schema.evaluate(data).output(:annotated, keywords: %w[title description default])

      expect(output["status"]).to eq(
        "title" => "Account Status",
        "description" => "Current state of the user account.",
        "default" => "active",
        "value" => "pending"
      )
    end
  end

  it "wraps array items with their item-schema annotations" do
    schema = build_schema(
      "type" => "array",
      "items" => {"type" => "string", "title" => "Tag"}
    )

    expect(schema.evaluate(%w[a b]).output(:annotated)).to eq(
      [
        {"title" => "Tag", "value" => "a"},
        {"title" => "Tag", "value" => "b"}
      ]
    )
  end

  it "surfaces annotations contributed through $ref" do
    schema = build_schema(
      "type" => "object",
      "properties" => {"home" => {"$ref" => "#/$defs/address"}},
      "$defs" => {
        "address" => {"type" => "string", "title" => "Address"}
      }
    )

    expect(schema.evaluate({"home" => "Main St"}).output(:annotated)).to eq(
      "home" => {"title" => "Address", "value" => "Main St"}
    )
  end

  it "wraps nodes without annotations as a bare value" do
    schema = build_schema(
      "type" => "object",
      "properties" => {"name" => {"type" => "string", "title" => "Name"}}
    )

    expect(schema.evaluate({"name" => "a", "extra" => 1}).output(:annotated)).to eq(
      "name" => {"title" => "Name", "value" => "a"},
      "extra" => {"value" => 1}
    )
  end

  it "drops annotations from failed branches" do
    schema = build_schema(
      "type" => "object",
      "properties" => {
        "id" => {
          "anyOf" => [
            {"type" => "integer", "title" => "Numeric ID"},
            {"type" => "string", "title" => "String ID"}
          ]
        }
      }
    )

    expect(schema.evaluate({"id" => 1}).output(:annotated)).to eq(
      "id" => {"title" => "Numeric ID", "value" => 1}
    )
  end
end
