# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class DynamicAnchor < Base
        self.key = "$dynamicAnchor"
        self.static = true

        def initialize(parent_schema, value)
          super

          base_uri = parent_schema.base_uri
          raise Error, "No base URI for `$dynamicAnchor` value `#{value}`" if base_uri.nil?

          uri = base_uri.dup.tap { |u| u.fragment = value }
          parent_schema.registry.add_schema(uri, parent_schema, cache_id: parent_schema.cache_id)
        end
      end
    end
  end
end
