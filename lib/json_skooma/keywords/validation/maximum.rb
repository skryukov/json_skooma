# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Maximum < Base
        self.key = "maximum"
        self.instance_types = "number"

        def evaluate(instance, result)
          result.failure(key) if instance > json
        end
      end
    end
  end
end
