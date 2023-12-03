# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Minimum < Base
        self.key = "minimum"
        self.instance_types = "number"

        def evaluate(instance, result)
          result.failure(key) if instance < json.value
        end
      end
    end
  end
end
