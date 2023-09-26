# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class Else < Base
        self.key = "else"
        self.value_schema = :schema
        self.depends_on = %w[if]

        def evaluate(instance, result)
          condition = result.sibling(instance, "if")
          if condition && !condition.valid?
            json.evaluate(instance, result)
          else
            result.discard
          end
        end
      end
    end
  end
end
