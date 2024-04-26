# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class Ref < Base
        self.key = "$ref"

        def resolve
          add_remote_source if need_to_adding?
          @ref_schema = parent_schema.resolve_ref(json)
        end

        def evaluate(instance, result)
          @ref_schema.evaluate(instance, result)
          result.ref_schema = @ref_schema
        end

        def add_remote_source
          parent_schema.registry.add_source(
            pathname.dirname.to_s + "/",
            JSONSkooma::Sources::Remote.new(json)
            # JSONSkooma::Sources::Remote.new(pathname.basename)
          )
        end

        def need_to_adding?
          json.start_with?("http") &&
            parent_schema.registry.instance_variable_get("@uri_sources").keys.none?{ |k| json.include?(k) }
        end

        def pathname
          Pathname.new(json)
        end
      end
    end
  end
end
