# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class Not < Base
        self.key = "not"
        self.value_schema = :schema

        def evaluate(instance, result)
          json.evaluate(instance, result)
          return result.success unless result.passed?

          result.failure(key)
        end
      end
    end
  end
end
