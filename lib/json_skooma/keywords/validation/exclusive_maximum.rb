# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class ExclusiveMaximum < Base
        self.key = "exclusiveMaximum"
        self.instance_types = "number"

        def evaluate(instance, result)
          if instance >= json
            result.failure("The value must be less than #{json.value})")
          end
        end
      end
    end
  end
end
