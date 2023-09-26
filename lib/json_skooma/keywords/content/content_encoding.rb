# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Content
      class ContentEncoding < BaseAnnotation
        self.key = "contentEncoding"
        self.instance_types = %w[string]
      end
    end
  end
end
