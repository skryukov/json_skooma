# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Const < Base
        self.key = "const"

        def evaluate(instance, result)
          return if instance == json

          result.failure(key)
        end
      end
    end
  end
end
