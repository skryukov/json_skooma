# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class Properties < Base
        self.key = "properties"
        self.instance_types = "object"
        self.value_schema = :object_of_schemas

        def evaluate(instance, result)
          annotation = []
          err_names = []
          instance.each do |name, item|
            next unless json.value.key?(name)

            result.call(item, name) do |subresult|
              json[name].evaluate(item, subresult)
              if subresult.passed?
                annotation << name
              else
                err_names << name
              end
            end
          end

          return result.annotate(annotation) if err_names.empty?

          result.failure("Properties #{err_names} are invalid")
        end
      end
    end
  end
end
