# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class AllOf < Base
        self.key = "allOf"
        self.value_schema = :array_of_schemas

        def evaluate(instance, result)
          error_indexes = []
          json.each.with_index do |subschema, index|
            result.call(instance, index.to_s) do |subresult|
              subschema.evaluate(instance, subresult)
              error_indexes << index unless subresult.passed?
            end
          end
          return if error_indexes.empty?

          result.failure(key, error_indexes: error_indexes)
        end
      end
    end
  end
end
