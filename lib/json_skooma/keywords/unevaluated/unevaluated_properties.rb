# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Unevaluated
      class UnevaluatedProperties < Base
        self.key = "unevaluatedProperties"
        self.instance_types = %w[object]
        self.value_schema = :schema
        self.depends_on = %w[
          properties patternProperties additionalProperties
          if then else dependentSchemas allOf anyOf oneOf not
        ]

        def evaluate(instance, result)
          evaluated_names = Set.new
          result.parent.collect_annotations(instance, "properties") { |name| evaluated_names += name }
          result.parent.collect_annotations(instance, "patternProperties") { |name| evaluated_names += name }
          result.parent.collect_annotations(instance, "additionalProperties") { |name| evaluated_names += name }
          result.parent.collect_annotations(instance, "unevaluatedProperties") { |name| evaluated_names += name }

          annotation = []
          error = []
          instance.each do |name, item|
            next if evaluated_names.include?(name)

            if json.evaluate(item, result).passed?
              annotation << name
            else
              error << name
              # reset to success for the next iteration
              result.success
            end
          end

          return result.failure(error) if error.any?

          result.annotate(annotation)
        end
      end
    end
  end
end
