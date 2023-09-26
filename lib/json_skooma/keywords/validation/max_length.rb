# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MaxLength < Base
        self.key = "maxLength"
        self.instance_types = "string"

        def evaluate(instance, result)
          if instance.length > json
            result.failure("The text is too long (maximum #{json.value} characters))")
          end
        end
      end
    end
  end
end
