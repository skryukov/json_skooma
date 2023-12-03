# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class OneOf < Base
        self.key = "oneOf"
        self.value_schema = :array_of_schemas

        def evaluate(instance, result)
          valid_indexes = []
          error_indexes = []

          json.each.with_index do |subschema, index|
            result.call(instance, index.to_s) do |subresult|
              subschema.evaluate(instance, subresult)
              if subresult.passed?
                valid_indexes << index
              else
                error_indexes << index
              end
            end
          end

          return if valid_indexes.size == 1

          result.failure(key, valid_indexes: valid_indexes, error_indexes: error_indexes)
        end
      end
    end
  end
end
