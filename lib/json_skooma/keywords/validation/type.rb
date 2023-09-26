# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Type < Base
        self.key = "type"

        def evaluate(instance, result)
          return if json.value.include?(instance.type)
          return if integer?(instance)

          result.failure("The instance must be of type #{json.value}, but was #{instance.type}")
        end

        private

        def integer?(instance)
          instance.type == "number" &&
            json.include?("integer") &&
            instance == instance.to_i
        end
      end
    end
  end
end
