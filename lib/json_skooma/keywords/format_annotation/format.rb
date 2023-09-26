# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module FormatAnnotation
      class Format < Base
        self.key = "format"

        def initialize(parent_schema, value)
          super
          if parent_schema.registry.format_enabled?(value)
            @validator = Validators.validators[value]
          end
        end

        def evaluate(instance, result)
          result.annotate(json)
          return result.skip_assertion unless @validator&.assert?(instance)

          @validator.call(instance)
        rescue Validators::FormatError => e
          result.failure("The instance is invalid against the #{json.value} format: #{e}")
        end
      end
    end
  end
end
