# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MaxContains < Base
        self.key = "maxContains"
        self.instance_types = %w[array]
        self.depends_on = %w[contains]

        def evaluate(instance, result)
          contains = result.sibling(instance, "contains")
          return if contains.nil?

          if contains.annotation && contains.annotation.length > json
            result.failure(
              "The array has too many elements matching the contains subschema (maximum #{json.value})"
            )
          end
        end
      end
    end
  end
end
