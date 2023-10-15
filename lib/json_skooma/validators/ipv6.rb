# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Ipv6 < Base
      H16 = /\h{1,4}/
      LS32 = /(?:#{H16}:#{H16})|#{Ipv4::IPV4_ADDRESS}/
      IPV6_ADDRESS = /(?:#{H16}:){6}#{LS32}|::(?:#{H16}:){5}#{LS32}|(?:#{H16})?::(?:#{H16}:){4}#{LS32}|(?:(?:#{H16}:){0,1}#{H16})?::(?:#{H16}:){3}#{LS32}|(?:(?:#{H16}:){0,2}#{H16})?::(?:#{H16}:){2}#{LS32}|(?:(?:#{H16}:){0,3}#{H16})?::(?:#{H16}:){1}#{LS32}|(?:(?:#{H16}:){0,4}#{H16})?::#{LS32}|(?:(?:#{H16}:){0,5}#{H16})?::#{H16}|(?:(?:#{H16}:){0,6}#{H16})?::/.freeze

      REGEXP = /\A#{IPV6_ADDRESS}\z/

      def call(data)
        match = REGEXP.match(data)
        raise FormatError, "must be a valid IPv6 address" if match.nil?
      end
    end
  end
end
