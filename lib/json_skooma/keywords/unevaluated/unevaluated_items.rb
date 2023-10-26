# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Unevaluated
      class UnevaluatedItems < Base
        self.key = "unevaluatedItems"
        self.instance_types = %w[array]
        self.value_schema = :schema
        self.depends_on = %w[
          prefixItems items contains
          if then else allOf anyOf oneOf not
          $ref $dynamicRef
        ]

        LOOKUP_KEYWORDS = %w[items unevaluatedItems prefixItems contains].freeze

        def evaluate(instance, result)
          contains_indices = Set.new
          last_evaluated_item = -1

          result.parent.collect_annotations(instance, keys: LOOKUP_KEYWORDS) do |node|
            next contains_indices += node.annotation if node.key == "contains"

            i = node.annotation
            next result.discard if i == true

            last_evaluated_item = i if node.key == "prefixItems" && i > last_evaluated_item
          end

          annotation = nil
          error = []

          instance.each_with_index do |item, index|
            next if last_evaluated_item >= index
            next if contains_indices.include?(index)

            if json.evaluate(item, result).passed?
              annotation = true
            else
              error << index
              # reset to passed for the next iteration
              result.success
            end
          end

          if error.any?
            result.failure(error)
          else
            result.annotate(annotation)
          end
        end
      end
    end
  end
end
