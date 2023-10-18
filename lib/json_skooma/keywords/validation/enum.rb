# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Enum < Base
        self.key = "enum"

        def evaluate(instance, result)
          return if json.include?(instance)

          result.failure(
            "The instance value #{instance.value} must be equal to one of the elements in the defined enumeration: #{json.value.join(", ")}"
          )
        end
      end
    end
  end
end
