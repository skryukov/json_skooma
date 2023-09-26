# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class Items < Base
        self.key = "items"
        self.instance_types = %w[array]
        self.value_schema = :schema
        self.depends_on = %w[prefixItems]

        def evaluate(instance, result)
          prefix_items = result.sibling(instance, "prefixItems")
          start_index = prefix_items&.schema_node&.length || 0

          annotation = nil
          error = []
          instance.each_with_index do |item, index|
            next if index < start_index

            if json.evaluate(item, result).passed?
              annotation = true
            else
              error << index
              # reset to passed for the next iteration
              result.success
            end
          end
          return result.annotate(annotation) if error.empty?

          result.failure(error)
        end
      end
    end
  end
end
