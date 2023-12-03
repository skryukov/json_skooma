# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Enum < Base
        self.key = "enum"

        def evaluate(instance, result)
          return if json.include?(instance)

          result.failure(key)
        end
      end
    end
  end
end
