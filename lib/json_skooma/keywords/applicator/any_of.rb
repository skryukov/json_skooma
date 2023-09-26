# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class AnyOf < Base
        self.key = "anyOf"
        self.value_schema = :array_of_schemas

        def evaluate(instance, result)
          valid = false
          json.each.with_index do |subschema, index|
            result.call(instance, index.to_s) do |subresult|
              subschema.evaluate(instance, subresult)
              valid = true if subresult.passed?
            end
          end

          return if valid

          result.failure("The instance must be valid against at least one subschema")
        end
      end
    end
  end
end
