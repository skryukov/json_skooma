# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Required < Base
        self.key = "required"
        self.instance_types = "object"

        def evaluate(instance, result)
          return if json.value.all? { |val| instance.key?(val) }

          result.failure(key)
        end
      end
    end
  end
end
