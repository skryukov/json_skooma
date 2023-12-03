# frozen_string_literal: true

require "bigdecimal"

module JSONSkooma
  module Keywords
    module Validation
      class MultipleOf < Base
        self.key = "multipleOf"
        self.instance_types = "number"

        def evaluate(instance, result)
          if BigDecimal(instance.value.to_s).modulo(BigDecimal(json.value.to_s)).nonzero?
            result.failure(key)
          end
        end
      end
    end
  end
end
