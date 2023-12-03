# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MinLength < Base
        self.key = "minLength"
        self.instance_types = "string"

        def evaluate(instance, result)
          result.failure(key) if instance.length < json
        end
      end
    end
  end
end
