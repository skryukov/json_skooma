# frozen_string_literal: true

require "uri/idna"

module JSONSkooma
  module Validators
    class IdnHostname < Base
      def call(data)
        URI::IDNA.register(ulabel: data.value)
      rescue URI::IDNA::Error => e
        raise FormatError, "#{data} is not a valid IDN hostname: #{e.message}"
      end
    end
  end
end
