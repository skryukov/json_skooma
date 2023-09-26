# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Unknown
      class << self
        def [](key)
          @unknown_keywords ||= {}
          @unknown_keywords[key] ||= Class.new(Keywords::Base) do
            self.key = key

            def evaluate(instance, result)
              result.annotate(json.value)
              result.skip_assertion
            end
          end
        end
      end
    end
  end
end
