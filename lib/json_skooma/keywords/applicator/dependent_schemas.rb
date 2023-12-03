# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class DependentSchemas < Base
        self.key = "dependentSchemas"
        self.instance_types = "object"
        self.value_schema = :object_of_schemas

        def evaluate(instance, result)
          annotation = []
          error_keys = []

          json.each do |name, subschema|
            next unless instance.key?(name)

            result.call(instance, name) do |subresult|
              if subschema.evaluate(instance, subresult).passed?
                annotation << name
              else
                error_keys << name
              end
            end
          end
          return result.annotate(annotation) if error_keys.none?

          result.failure(key, error_keys: error_keys)
        end
      end
    end
  end
end
