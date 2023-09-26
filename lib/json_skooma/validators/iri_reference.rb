# frozen_string_literal: true

module JSONSkooma
  module Validators
    class IriReference < Base
      REGEX = /\A#{Iri::IRI_REFERENCE}\z/.freeze

      def call(data)
        return if REGEX.match?(data.value)

        raise FormatError, "#{data} is not a valid IRI reference"
      end
    end
  end
end
