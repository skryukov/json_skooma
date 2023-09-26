# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class ExclusiveMinimum < Base
        self.key = "exclusiveMinimum"
        self.instance_types = "number"

        def evaluate(instance, result)
          if instance <= json
            result.failure("The value must be greater than #{json.value})")
          end
        end
      end
    end
  end
end
