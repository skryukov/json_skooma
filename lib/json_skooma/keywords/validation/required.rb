# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Required < Base
        self.key = "required"
        self.instance_types = "object"

        def evaluate(instance, result)
          missing_keys = json - instance.keys
          return if missing_keys.empty?

          result.failure("The object is missing required properties #{json.value}")
        end
      end
    end
  end
end
