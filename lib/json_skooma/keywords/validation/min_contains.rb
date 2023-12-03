# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MinContains < Base
        self.key = "minContains"
        self.instance_types = %w[array]
        self.depends_on = %w[contains maxContains]

        def evaluate(instance, result)
          contains = result.sibling(instance, "contains")
          return if contains.nil?

          contains_count = contains.annotation&.count || 0

          valid = contains_count >= json

          if valid && !contains.valid?
            max_contains = result.sibling(instance, "maxContains")
            contains.success if !max_contains || max_contains.valid?
          end

          return if valid

          result.failure(key)
        end
      end
    end
  end
end
