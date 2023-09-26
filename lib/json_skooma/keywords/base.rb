# frozen_string_literal: true

module JSONSkooma
  module Keywords
    class Base
      attr_reader :json, :parent_schema

      class << self
        attr_accessor :static, :depends_on, :schema_value_class
        attr_writer :key
        attr_reader :instance_types

        def key
          @key or raise "Key must be defined"
        end

        def instance_types=(value)
          @instance_types = Array(value)
        end

        def value_schema=(schema_keys)
          Array(schema_keys).each do |k|
            prepend ValueSchemas[k]
          end
        end

        def set_defaults
          @instance_types = %w[boolean object array string number null]
          @static = false
          @depends_on = []
        end

        def inherited(subclass)
          subclass.set_defaults
        end
      end

      def initialize(parent_schema, value)
        @parent_schema = parent_schema
        @json = wrap_value(value)
      end

      def key
        self.class.key
      end

      def static
        self.class.static
      end

      def instance_types
        self.class.instance_types
      end

      def evaluate(instance, result)
      end

      def each_schema(&block)
      end

      def resolve
        each_schema do |schema|
          schema.resolve_references if schema.respond_to?(:resolve_references)
        end
      end

      private

      def wrap_value(value)
        JSONNode.new(value, key: key, parent: parent_schema)
      end
    end
  end
end
