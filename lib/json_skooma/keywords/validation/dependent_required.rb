# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class DependentRequired < Base
        self.key = "dependentRequired"
        self.instance_types = "object"

        def evaluate(instance, result)
          missing = {}
          json.each do |name, dependents|
            next unless instance.key?(name)

            missing_deps = dependents.reject { |dep| instance.key?(dep) }
            missing[name] = missing_deps if missing_deps.any?
          end

          result.failure("The object is missing dependent properties #{missing}") if missing.any?
        end
      end
    end
  end
end
