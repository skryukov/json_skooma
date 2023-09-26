# frozen_string_literal: true

module JSONSkooma
  module Keywords
    class BaseAnnotation < Base
      def evaluate(instance, result)
        result.annotate(json.value)
        result.skip_assertion
      end
    end
  end
end
