# JSONSkooma – Sugar for your JSONs

[![Gem Version](https://badge.fury.io/rb/json_skooma.svg)](https://rubygems.org/gems/json_skooma)
[![Ruby](https://github.com/skryukov/json_skooma/actions/workflows/main.yml/badge.svg)](https://github.com/skryukov/json_skooma/actions/workflows/main.yml)

<img align="right" height="150" width="150" title="JSONSkooma logo" src="./assets/logo.svg">

JSONSkooma is a Ruby library for validating JSONs against JSON Schemas.

### Features

- Supports JSON Schema 2019-09 and 2020-12
- Supports custom dialects, vocabularies, keywords, format validators, output formatters 
- Supports custom schema resolvers

<a href="https://evilmartians.com/?utm_source=json_skooma&utm_campaign=project_page">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Built by Evil Martians" width="236" height="54">
</a>

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add json_skooma

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install json_skooma

## Usage

```ruby
require "json_skooma"

# Create a registry to store schemas, vocabularies, dialects, etc.
JSONSkooma.create_registry("2020-12", assert_formats: true)

# Load a schema
schema_hash = {
  "$schema" => "https://json-schema.org/draft/2020-12/schema",
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

schema = JSONSkooma::JSONSchema.new(schema_hash)

data_hash = {
  name: "Matz",
  race: "Human",
  class: "Dragonborn",
  level: 50,
  equipment: %w[Ruby],
}

result = schema.evaluate(data_hash)

result.valid? # => false

result.output(:basic)
# {"valid"=>false,
#  "errors"=>
#    [{"instanceLocation"=>"",
#      "keywordLocation"=>"/properties",
#      "absoluteKeywordLocation"=>"urn:uuid:f477b6ca-7308-4be6-b88c-e848b9002793#/properties",
#      "error"=>"Properties [\"race\"] are invalid"},
#     {"instanceLocation"=>"/race",
#      "keywordLocation"=>"/properties/race/enum",
#      "absoluteKeywordLocation"=>"urn:uuid:f477b6ca-7308-4be6-b88c-e848b9002793#/properties/race/enum",
#      "error"=>
#        "The instance value \"Human\" must be equal to one of the elements in the defined enumeration: [\"Nord\", \"Khajiit\", \"Argonian\", \"Breton\", \"Redguard\", \"Dunmer\", \"Altmer\", \"Bosmer\", \"Orc\", \"Imperial\"]"}]}
```

### Evaluating against a reference

```ruby
require "json_skooma"

# Create a registry to store schemas, vocabularies, dialects, etc.
JSONSkooma.create_registry("2020-12", assert_formats: true)

# Load a schema
schema_hash = {
  "$schema" => "https://json-schema.org/draft/2020-12/schema",
  "$defs" => {
    "Foo": {
      "type" => "object",
      "properties" => { 
        "foo" => {"enum" => ["baz"]}
      },
    }
  }
}

schema = JSONSkooma::JSONSchema.new(schema_hash)

result = schema.evaluate({foo: "bar"}, ref: "#/$defs/Foo")

result.valid? # => false

result.output(:basic)
# {"valid"=>false,
#  "errors"=>
#   [{"instanceLocation"=>"", "keywordLocation"=>"/properties", "absoluteKeywordLocation"=>"urn:uuid:cb8fb0a0-ce16-416f-b5ba-2a6531992be9#/$defs/Foo/properties", "error"=>"Properties [\"foo\"] are invalid"},
#    {"instanceLocation"=>"/foo",
#     "keywordLocation"=>"/properties/foo/enum",
#     "absoluteKeywordLocation"=>"urn:uuid:cb8fb0a0-ce16-416f-b5ba-2a6531992be9#/$defs/Foo/properties/foo/enum",
#     "error"=>"The instance value \"bar\" must be equal to one of the elements in the defined enumeration: [\"baz\"]"}]}
```

### Handling External `$ref`s in JSON Schemas

In `JSONSkooma`, you can map `$ref` identifiers in your JSON schemas to local or remote sources.

This configuration allows `JSONSkooma` to automatically link `$ref` URIs to their corresponding schemas from specified sources:

```yaml
# schema.yml
$schema: https://json-schema.org/draft/2020-12/schema
type: object
properties:
  user:
    $ref: http://local.example/user_definition.yaml
  product:
    $ref: http://remote.example/product_definition.yaml
```

```ruby
# Initialize the JSONSkooma registry
schema_registry = JSONSkooma.create_registry("2020-12")

# Add a local source for user definitions
local_schemas_path = File.join(__dir__, "schemas", "local")
schema_registry.add_source(
  "http://local.example/",
  JSONSkooma::Sources::Local.new(local_schemas_path)
)

# Add a remote source for product definitions
schema_registry.add_source(
  "http://remote.example/",
  JSONSkooma::Sources::Remote.new("http://example.com/schemas/")
)

# JSONSkooma now automatically resolves `$refs` to the appropriate schemas:
# - http://local.example/user_definition.yaml -> ./schemas/local/user_definition.yaml
# - http://remote.example/product_definition.yaml -> http://example.com/schemas/product_definition.yaml
```

## Alternatives

- [json_schemer](https://github.com/davishmcclurg/json_schemer) – Draft 4, 6, 7, 2019-09 and 2020-12 compliant
- [json-schema](https://github.com/voxpupuli/json-schema) – Draft 1, 2, 3, 4 and 6 compliant

## Feature plans

- Custom error messages
- EcmaScript regexp
- Short circuit errors
- IRI as schema identifiers
- Relative JSONPointer
- More unit tests

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skryukov/json_skooma.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
