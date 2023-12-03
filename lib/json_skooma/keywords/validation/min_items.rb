# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MinItems < Base
        self.key = "minItems"
        self.instance_types = "array"

        def evaluate(instance, result)
          result.failure(key) if instance.length < json
        end
      end
    end
  end
end
