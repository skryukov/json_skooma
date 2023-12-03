# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Ipv4 < Base
      self.key = "ipv4"

      IPV4_ADDRESS = "(?:(?:25[0-5]|(?:2[0-4]|1\\d|[1-9])?\\d)\\.?\\b){4}"
      REGEXP = /\A#{IPV4_ADDRESS}\z/

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
