# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class Schema < Base
        self.key = "$schema"
        self.static = true

        def initialize(parent_schema, value)
          super

          # todo: validate URI.validate(require_scheme=True, require_normalized=True)
          uri = URI.parse(value)
          parent_schema.metaschema_uri = uri

          if parent_schema.is_a?(Metaschema)
            metaschema = parent_schema.registry.metaschema(uri)
            parent_schema.core_vocabulary ||= metaschema.core_vocabulary
            parent_schema.default_vocabularies ||= metaschema.default_vocabularies
          end
        end
      end
    end
  end
end
