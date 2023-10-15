# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Minimum < Base
        self.key = "minimum"
        self.instance_types = "number"

        def evaluate(instance, result)
          if instance < json.value
            result.failure("The value may not be less than #{json.value})")
          end
        end
      end
    end
  end
end
