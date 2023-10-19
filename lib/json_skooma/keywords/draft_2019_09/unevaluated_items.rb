# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Draft201909
      class UnevaluatedItems < Base
        self.key = "unevaluatedItems"
        self.instance_types = %w[array]
        self.value_schema = :schema
        self.depends_on = %w[
          items additionalItems
          if then else allOf anyOf oneOf not
        ]

        LOOKUP_KEYWORDS = %w[items additionalItems unevaluatedItems].freeze

        def evaluate(instance, result)
          last_evaluated_item = -1

          result.parent.collect_annotations(instance, keys: LOOKUP_KEYWORDS) do |node|
            i = node.annotation
            next result.discard if i == true

            last_evaluated_item = i if node.key == "items" && i > last_evaluated_item
          end

          annotation = nil
          error = []

          instance.each_with_index do |item, index|
            next if last_evaluated_item >= index

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
