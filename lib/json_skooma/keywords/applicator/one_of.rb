# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class OneOf < Base
        self.key = "oneOf"
        self.value_schema = :array_of_schemas

        def evaluate(instance, result)
          valid_indices = []
          err_indices = []

          json.each.with_index do |subschema, index|
            result.call(instance, index.to_s) do |subresult|
              subschema.evaluate(instance, subresult)
              if subresult.passed?
                valid_indices << index
              else
                err_indices << index
              end
            end
          end

          return if valid_indices.size == 1

          result.failure(
            "The instance must be valid against exactly one subschema; " \
            "it is valid against #{valid_indices} and invalid against #{err_indices}'"
          )
        end
      end
    end
  end
end
