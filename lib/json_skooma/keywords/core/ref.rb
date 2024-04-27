# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class Ref < Base
        self.key = "$ref"

        def resolve
          @ref_schema = parent_schema.resolve_ref(json)
        end

        def evaluate(instance, result)
          @ref_schema.evaluate(instance, result)
          result.ref_schema = @ref_schema
        end
      end
    end
  end
end
