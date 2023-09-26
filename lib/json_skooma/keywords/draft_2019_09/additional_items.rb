# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Draft201909
      class AdditionalItems < Base
        self.key = "additionalItems"
        self.instance_types = "array"
        self.value_schema = :schema
        self.depends_on = %w[items]

        def evaluate(instance, result)
          items = result.sibling(instance, "items")
          return result.discard unless items&.annotation.is_a?(Integer)

          annotation = nil
          error = []

          instance.each_with_index do |item, index|
            next if items.annotation >= index

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
