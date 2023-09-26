# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class Id < Base
        self.key = "$id"
        self.static = true

        def initialize(parent_schema, value)
          super

          uri = URI.parse(value)
          if uri.relative?
            base_uri = parent_schema.base_uri
            if base_uri
              uri = base_uri + uri
            else
              raise "No base URI against which to resolve the `$id` value `#{value}`"
            end
          end

          parent_schema.uri = uri
        end
      end
    end
  end
end
