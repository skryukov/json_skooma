# frozen_string_literal: true

require "uri/idna"

module JSONSkooma
  module Validators
    class IdnHostname < Base
      def call(data)
        register_opts = data.value.ascii_only? ? {alabel: data.value} : {ulabel: data.value}
        URI::IDNA.register(**register_opts)
      rescue URI::IDNA::Error => e
        raise FormatError, "#{data} is not a valid IDN hostname: #{e.message}"
      end
    end
  end
end
