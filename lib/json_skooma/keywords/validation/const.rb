# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Const < Base
        self.key = "const"

        def evaluate(instance, result)
          return if instance == json

          result.failure("The instance value #{instance.value.inspect} must be equal to the defined constant #{json.value.inspect}")
        end
      end
    end
  end
end
