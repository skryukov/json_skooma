# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class MaxProperties < Base
        self.key = "maxProperties"
        self.instance_types = "object"

        def evaluate(instance, result)
          result.failure(key) if instance.length > json
        end
      end
    end
  end
end
