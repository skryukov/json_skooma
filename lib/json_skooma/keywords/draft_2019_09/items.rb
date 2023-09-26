# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Draft201909
      class Items < Base
        self.key = "items"
        self.instance_types = %w[array]
        self.value_schema = [:schema, :array_of_schemas]

        def evaluate(instance, result)
          return if instance.empty?

          if json.type == "boolean"
            json.evaluate(instance, result)
          elsif json.is_a?(JSONSchema)
            instance.each do |item|
              json.evaluate(item, result)
            end
            result.annotate(true) if result.passed?
          elsif json.type == "array"
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

            result.annotate(annotation)
          end
        end
      end
    end
  end
end
