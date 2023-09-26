# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Applicator
      class PrefixItems < Base
        self.key = "prefixItems"
        self.instance_types = "array"
        self.value_schema = :array_of_schemas

        def evaluate(instance, result)
          annotation = nil
          error = []
          instance.take(json.length).each_with_index do |item, index|
            annotation = index
            result.call(item, index.to_s) do |subresult|
              unless json[index].evaluate(item, subresult).passed?
                error << index
              end
            end
          end
          return result.failure(error) unless error.empty?
          return if annotation.nil?

          annotation = true if annotation == instance.length - 1
          result.annotate(annotation)
        end
      end
    end
  end
end
