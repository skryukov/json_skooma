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

        def evaluate(instance, result)
          last_evaluated_item = -1

          result.parent.collect_annotations(instance, "items") do |i|
            next result.discard if i == true

            last_evaluated_item = i if i > last_evaluated_item
          end

          result.parent.collect_annotations(instance, "additionalItems") do |i|
            next result.discard if i == true
          end

          result.parent.collect_annotations(instance, "unevaluatedItems") do |i|
            next result.discard if i == true
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
