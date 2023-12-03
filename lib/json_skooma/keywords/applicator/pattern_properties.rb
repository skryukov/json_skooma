# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class PatternProperties < Base
        self.key = "patternProperties"
        self.instance_types = "object"
        self.value_schema = :object_of_schemas

        def initialize(parent_schema, value)
          super
          @patterned = json.map do |pattern, subschema|
            [Regexp.new(pattern), pattern, subschema]
          end
        end

        def evaluate(instance, result)
          matched_names = Set.new
          error_keys = []

          instance.each do |name, item|
            @patterned.each do |regexp, pattern, subschema|
              if regexp.match?(name)
                result.call(item, pattern) do |subresult|
                  subschema.evaluate(item, subresult)
                  if subresult.passed?
                    matched_names << name
                  else
                    error_keys << name
                  end
                end
              end
            end
          end

          if error_keys.any?
            result.failure(key, error_keys: error_keys)
          else
            result.annotate(matched_names.to_a)
          end
        end
      end
    end
  end
end
