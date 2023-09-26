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
          err_names = []

          json.each do |name, subschema|
            next unless instance.key?(name)

            result.call(instance, name) do |subresult|
              if subschema.evaluate(instance, subresult).passed?
                annotation << name
              else
                err_names << name
              end
            end
          end
          return result.annotate(annotation) if err_names.none?

          result.failure(
            "Properties #{err_names} are invalid against the corresponding `dependentSchemas` subschemas"
          )
        end
      end
    end
  end
end
