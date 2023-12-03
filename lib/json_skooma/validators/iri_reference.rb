# frozen_string_literal: true

module JSONSkooma
  module Validators
    class IriReference < Base
      self.key = "iri-reference"

      REGEXP = /\A#{Iri::IRI_REFERENCE}\z/.freeze

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
