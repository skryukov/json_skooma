# frozen_string_literal: true

require "uri/idna"

module JSONSkooma
  module Validators
    class IdnHostname < Base
      self.key = "idn-hostname"

      def call
        register_opts = instance.value.ascii_only? ? {alabel: instance.value} : {ulabel: instance.value}
        URI::IDNA.register(**register_opts)
      rescue URI::IDNA::Error => e
        failure!(message: e.message)
      end
    end
  end
end
