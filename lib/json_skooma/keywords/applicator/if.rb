# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class If < Base
        self.key = "if"
        self.value_schema = :schema

        def evaluate(instance, result)
          json.evaluate(instance, result)
          result.skip_assertion
        end
      end
    end
  end
end
