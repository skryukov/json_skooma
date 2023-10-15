# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Ipv4 < Base
      IPV4_ADDRESS = /((25[0-5]|(2[0-4]|1\d|[1-9])?\d)\.?\b){4}/
      REGEXP = /\A#{IPV4_ADDRESS}\z/

      class << self
        def call(data)
          match = REGEXP.match(data)
          raise FormatError, "must be a valid IPv4 address" if match.nil?
        end
      end
    end
  end
end
