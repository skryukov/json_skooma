# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class PropertyNames < Base
        self.key = "propertyNames"
        self.instance_types = "object"
        self.value_schema = :schema

        def evaluate(instance, result)
          error = []
          instance.each do |name,|
            next if json.evaluate(JSONNode.new(name, key: name, parent: instance), result).passed?

            error << name
            result.success
          end

          result.failure(error) if error.any?
        end
      end
    end
  end
end
