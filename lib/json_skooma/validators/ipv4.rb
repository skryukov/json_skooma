# frozen_string_literal: true

require "ipaddr"

module JSONSkooma
  module Validators
    class Ipv4 < Base
      self.class

      class << self
        def call(data)
          ip = IPAddr.new "#{data.value}/24"
          raise FormatError, "must be a valid IPv4 address" unless ip.ipv4?
        rescue IPAddr::Error => e
          raise FormatError, e.message
        end
      end
    end
  end
end
