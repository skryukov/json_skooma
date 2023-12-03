# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Pattern < Base
        self.key = "pattern"
        self.instance_types = %w[string]

        def initialize(parent_schema, value)
          super
          @regexp = Regexp.new(value)
        end

        def evaluate(instance, result)
          return if @regexp.match(instance)

          result.failure(key)
        end
      end
    end
  end
end
