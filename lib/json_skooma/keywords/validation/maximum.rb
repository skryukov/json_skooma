# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Maximum < Base
        self.key = "maximum"
        self.instance_types = "number"

        def evaluate(instance, result)
          if instance > json
            result.failure("The value may not be greater than #{json.value})")
          end
        end
      end
    end
  end
end
