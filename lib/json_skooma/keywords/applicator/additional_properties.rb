# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class AdditionalProperties < Base
        self.key = "additionalProperties"
        self.instance_types = "object"
        self.value_schema = :schema
        self.depends_on = %w[properties patternProperties]

        def evaluate(instance, result)
          known_property_names = result.sibling(instance, "properties")&.schema_node&.keys || []
          known_property_patterns = result.sibling(instance, "patternProperties")&.schema_node&.keys || []

          annotation = []
          error = []

          instance.each do |name, item|
            if !known_property_names.include?(name) && !known_property_patterns.any? { |pattern| Regexp.new(pattern).match?(name) }
              if json.evaluate(item, result).passed?
                annotation << name
              else
                error << name
                # reset to success for the next iteration
                result.success
              end
            end
          end
          return result.annotate(annotation) if error.empty?

          result.failure(error)
        end
      end
    end
  end
end
