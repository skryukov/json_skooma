# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Hostname < Base
      HOSTNAME = /(?=.{1,253}\.?\z)[a-z\d](?:[a-z\d-]{0,61}[a-z\d])?(?:\.[a-z\d](?:[a-z\d-]{0,61}[a-z\d])?)*\.?/

      REGEXP = /\A#{HOSTNAME}\z/i

      def call(data)
        return if REGEXP.match?(data.value)

        raise FormatError, "#{data} is not a valid hostname"
      end
    end
  end
end
