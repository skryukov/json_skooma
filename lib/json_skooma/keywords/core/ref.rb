# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class Ref < Base
        self.key = "$ref"

        def resolve
          uri = resolve_uri
          @ref_schema = parent_schema.registry.schema(
            uri,
            metaschema_uri: parent_schema.metaschema_uri,
            cache_id: parent_schema.cache_id
          )
        end

        def evaluate(instance, result)
          @ref_schema.evaluate(instance, result)
          result.ref_schema = @ref_schema
        end

        private

        def resolve_uri
          uri = URI.parse(json)
          return uri if uri.absolute?
          return parent_schema.base_uri + uri if parent_schema.base_uri

          raise Error, "No base URI against which to resolve the `$ref` value `#{uri}`"
        end
      end
    end
  end
end
