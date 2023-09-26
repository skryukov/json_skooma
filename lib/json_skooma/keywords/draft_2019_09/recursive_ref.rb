# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Draft201909
      class RecursiveRef < Base
        self.key = "$recursiveRef"

        def initialize(parent_schema, value)
          super
          raise "`$recursiveRef` may only take the value `#`" if value != "#"
        end

        def resolve
          base_uri = parent_schema.base_uri
          if base_uri.nil?
            raise "No base URI against which to resolve the `$recursiveRef`"
          end

          @ref_schema = parent_schema.registry.schema(
            base_uri,
            metaschema_uri: parent_schema.metaschema_uri,
            cache_id: parent_schema.cache_id
          )
        end

        def evaluate(instance, result)
          ref_schema = @ref_schema
          recursive_anchor = ref_schema["$recursiveAnchor"]
          if recursive_anchor&.value
            target = result
            while target
              base_anchor = target.schema["$recursiveAnchor"]
              if base_anchor&.value
                ref_schema = target.schema
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
