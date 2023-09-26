# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class Defs < Base
        self.key = "$defs"
        self.static = true
        self.value_schema = :object_of_schemas
      end
    end
  end
end
