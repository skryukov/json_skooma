# frozen_string_literal: true

require "ipaddr"

module JSONSkooma
  module Validators
    class Ipv6 < Base
      def call(data)
        ip = IPAddr.new "#{data.value}/64"
        raise FormatError, "must be a valid IPv6 address" unless ip.ipv6? && ip.zone_id.nil?
      rescue IPAddr::Error => e
        raise FormatError, e.message
      end
    end
  end
end
