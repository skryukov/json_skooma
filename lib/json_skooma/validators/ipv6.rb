# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Ipv6 < Base
      self.key = "ipv6"

      h16 = /\h{1,4}/
      ls32 = /(?:#{h16}:#{h16})|#{Ipv4::IPV4_ADDRESS}/
      IPV6_ADDRESS = /(?:#{h16}:){6}#{ls32}|::(?:#{h16}:){5}#{ls32}|(?:#{h16})?::(?:#{h16}:){4}#{ls32}|(?:(?:#{h16}:){0,1}#{h16})?::(?:#{h16}:){3}#{ls32}|(?:(?:#{h16}:){0,2}#{h16})?::(?:#{h16}:){2}#{ls32}|(?:(?:#{h16}:){0,3}#{h16})?::(?:#{h16}:){1}#{ls32}|(?:(?:#{h16}:){0,4}#{h16})?::#{ls32}|(?:(?:#{h16}:){0,5}#{h16})?::#{h16}|(?:(?:#{h16}:){0,6}#{h16})?::/.freeze
      REGEXP = /\A#{IPV6_ADDRESS}\z/

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
