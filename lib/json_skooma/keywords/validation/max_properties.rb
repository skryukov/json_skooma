# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MaxProperties < Base
        self.key = "maxProperties"
        self.instance_types = "object"

        def evaluate(instance, result)
          if instance.length > json
            result.failure("The object has too many properties (maximum #{json.value})")
          end
        end
      end
    end
  end
end
