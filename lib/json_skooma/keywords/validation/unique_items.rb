# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Validation
      class UniqueItems < Base
        self.key = "uniqueItems"
        self.instance_types = "array"

        def evaluate(instance, result)
          return unless json.value

          if instance.uniq.size != instance.size
            result.failure(key)
          end
        end
      end
    end
  end
end
