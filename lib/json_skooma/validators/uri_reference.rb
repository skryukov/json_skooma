# frozen_string_literal: true

module JSONSkooma
  module Validators
    class UriReference < Base
      REGEX = /\A#{Uri::URI_REFERENCE}\z/.freeze

      def call(data)
        return if REGEX.match?(data.value)

        raise FormatError, "#{data} is not a valid URI reference"
      end
    end
  end
end
