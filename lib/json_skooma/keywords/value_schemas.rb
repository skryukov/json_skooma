# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module ValueSchemas
      class << self
        def [](key)
          value_schemas&.[](key) or raise "Unknown value schema: #{key}, known schemas: #{value_schemas.keys.inspect}"
        end

        def register_value_schema(key, klass)
          (self.value_schemas ||= {})[key] = klass
        end

        private

        attr_accessor :value_schemas
      end

      module Schema
        def wrap_value(value)
          return super unless value.is_a?(Hash) || value.is_a?(TrueClass) || value.is_a?(FalseClass)

          (self.class.schema_value_class || JSONSchema).new(
            value,
            parent: parent_schema,
            key: key,
            registry: parent_schema.registry,
            cache_id: parent_schema.cache_id
          )
        end

        def each_schema
          return super unless json.is_a?(JSONSchema)

          yield json
        end
      end
      register_value_schema(:schema, Schema)

      module ArrayOfSchemas
        def wrap_value(value)
          return super unless value.is_a?(Array)

          JSONNode.new(
            value,
            parent: parent_schema,
            key: key,
            item_class: self.class.schema_value_class || JSONSchema,
            registry: parent_schema.registry,
            cache_id: parent_schema.cache_id
          )
        end

        def each_schema(&block)
          return super unless json.type == "array"

          json.each(&block)
        end
      end

      register_value_schema(:array_of_schemas, ArrayOfSchemas)

      module ObjectOfSchemas
        def wrap_value(value)
          return super unless value.is_a?(Hash)

          JSONNode.new(
            value,
            parent: parent_schema,
            key: key,
            item_class: self.class.schema_value_class || JSONSchema,
            registry: parent_schema.registry,
            cache_id: parent_schema.cache_id
          )
        end

        def each_schema(&block)
          return super unless json.type == "object"

          json.each_value(&block)
        end
      end
      register_value_schema(:object_of_schemas, ObjectOfSchemas)
    end
  end
end
