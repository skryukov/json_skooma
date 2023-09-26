# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Content
      class ContentSchema < BaseAnnotation
        self.key = "contentSchema"
        self.instance_types = %w[string]
        self.depends_on = %w[contentMediaType]

        def evaluate(instance, result)
          return super if result.sibling(instance, "contentMediaType")

          result.discard
        end
      end
    end
  end
end
