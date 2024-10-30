# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class Required < Base
        self.key = "required"
        self.instance_types = "object"

        def evaluate(instance, result)
          missing = required_keys.reject { |key| instance.key?(key) }
          return if missing.none?

          result.failure(missing_keys_message(missing))
        end

        private

        def required_keys
          json.value
        end

        def missing_keys_message(missing)
          "The object requires the following keys: #{required_keys.join(", ")}. Missing keys: #{missing.join(", ")}"
        end
      end
    end
  end
end
