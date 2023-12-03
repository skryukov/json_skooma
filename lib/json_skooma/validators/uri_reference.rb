# frozen_string_literal: true

module JSONSkooma
  module Validators
    class UriReference < Base
      self.key = "uri-reference"

      REGEXP = /\A#{Uri::URI_REFERENCE}\z/.freeze

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
