# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class Contains < Base
        self.key = "contains"
        self.instance_types = "array"
        self.value_schema = :schema

        def evaluate(instance, result)
          annotation = []
          instance.each_with_index do |item, index|
            if json.evaluate(item, result).passed?
              annotation << index
            else
              result.success
            end
          end
          result.annotate(annotation)

          return if annotation.any?

          result.failure(
            "The array does not contain any element that is valid against the `#{key}` subschema"
          )
        end
      end
    end
  end
end
