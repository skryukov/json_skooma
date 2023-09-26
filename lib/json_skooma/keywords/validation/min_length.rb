# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MinLength < Base
        self.key = "minLength"
        self.instance_types = "string"

        def evaluate(instance, result)
          if instance.length < json
            result.failure("The text is too short (minimum #{json.value} characters))")
          end
        end
      end
    end
  end
end
