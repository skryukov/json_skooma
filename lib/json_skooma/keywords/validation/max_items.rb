# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MaxItems < Base
        self.key = "maxItems"
        self.instance_types = "array"

        def evaluate(instance, result)
          if instance.length > json
            result.failure("The array has too many elements (maximum #{json.value})")
          end
        end
      end
    end
  end
end
