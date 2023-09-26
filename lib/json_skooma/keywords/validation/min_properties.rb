# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MinProperties < Base
        self.key = "minProperties"
        self.instance_types = "object"

        def evaluate(instance, result)
          if instance.length < json
            result.failure("The object has too few properties (minimum #{json.value})")
          end
        end
      end
    end
  end
end
