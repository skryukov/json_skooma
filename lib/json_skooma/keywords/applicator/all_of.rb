# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class AllOf < Base
        self.key = "allOf"
        self.value_schema = :array_of_schemas

        def evaluate(instance, result)
          err_indices = []
          json.each.with_index do |subschema, index|
            result.call(instance, index.to_s) do |subresult|
              subschema.evaluate(instance, subresult)
              err_indices << index unless subresult.passed?
            end
          end
          return if err_indices.empty?

          result.failure("The instance is invalid against subschemas #{err_indices.join(", ")}")
        end
      end
    end
  end
end
