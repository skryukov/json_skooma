# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class DynamicRef < Base
        self.key = "$dynamicRef"

        def initialize(parent_schema, value)
          super
          @fragment = URI.parse(value).fragment
          @dynamic = false
        end

        def resolve
          uri = URI.parse(json)
          if uri.relative?
            base_uri = parent_schema.base_uri
            if base_uri.nil?
              raise "No base URI against which to resolve the `$dynamicRef` value `#{uri}`"
            end

            uri = base_uri + uri
          end
          @ref_schema = parent_schema.registry.schema(
            uri,
            metaschema_uri: parent_schema.metaschema_uri,
            cache_id: parent_schema.cache_id
          )
          dynamic_anchor = @ref_schema["$dynamicAnchor"]
          @dynamic = dynamic_anchor == @fragment
        end

        def evaluate(instance, result)
          ref_schema = @ref_schema
          if @dynamic
            target = result
            checked_uris = Set.new
            while target
              base_uri = target.schema.base_uri
              if base_uri && !checked_uris.include?(base_uri)
                checked_uris << base_uri
                target_uri = base_uri.dup.tap { |u| u.fragment = @fragment }

                begin
                  found_schema = parent_schema.registry.schema(
                    target_uri,
                    cache_id: parent_schema.cache_id
                  )
                  dynamic_anchor = found_schema["$dynamicAnchor"]
                  ref_schema = found_schema if dynamic_anchor == @fragment
                rescue RegistryError, Hana::Pointer::FormatError
                  # do nothing
                end
              end

              target = target.parent
            end
          end

          ref_schema.evaluate(instance, result)
          result.ref_schema = ref_schema
        end
      end
    end
  end
end
