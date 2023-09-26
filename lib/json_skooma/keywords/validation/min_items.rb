# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MinItems < Base
        self.key = "minItems"
        self.instance_types = "array"

        def evaluate(instance, result)
          if instance.length < json
            result.failure("The array has too few elements (minimum #{json.value})")
          end
        end
      end
    end
  end
end
