# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MaxLength < Base
        self.key = "maxLength"
        self.instance_types = "string"

        def evaluate(instance, result)
          result.failure(key) if instance.length > json
        end
      end
    end
  end
end
