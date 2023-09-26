# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Content
      class ContentMediaType < BaseAnnotation
        self.key = "contentMediaType"
        self.instance_types = %w[string]
      end
    end
  end
end
