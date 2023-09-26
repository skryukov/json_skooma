# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Uri < Base
      SUB_DELIMS = /[!$&'()*+,;=]/.freeze
      GEN_DELIMS = /[:\/?#\[\]@]/.freeze
      RESERVED = /(?:#{GEN_DELIMS}|#{SUB_DELIMS})/.freeze
      UNRESERVED = /[A-Za-z\d\-._~]/.freeze
      PCT_ENCODED = /%\h{2}/.freeze
      PCHAR = /(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|[:@])/.freeze
      FRAGMENT = /(?:#{PCHAR}|[?\/])*/.freeze
      QUERY = FRAGMENT

      SEGMENT = /#{PCHAR}*/.freeze
      SEGMENT_NZ = /#{PCHAR}+/.freeze
      SEGMENT_NZ_NC = /(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|@)+/.freeze

      PATH_ABEMPTY = /(?:\/#{SEGMENT})*/.freeze
      PATH_ABSOLUTE = /\/(?:#{SEGMENT_NZ}(?:\/#{SEGMENT})*)?/.freeze
      PATH_NOSCHEME = /#{SEGMENT_NZ_NC}(?:\/#{SEGMENT})*/.freeze
      PATH_ROOTLESS = /#{SEGMENT_NZ}(?:\/#{SEGMENT})*/.freeze
      PATH = /(?:#{PATH_ABEMPTY}|#{PATH_ABSOLUTE}|#{PATH_NOSCHEME}|#{PATH_ROOTLESS})?/.freeze

      IPV4_ADDRESS = /((25[0-5]|(2[0-4]|1\d|[1-9])?\d)\.?\b){4}/
      H16 = /\h{1,4}/
      LS32 = /(?:#{H16}:#{H16})|#{IPV4_ADDRESS}/
      IPV6_ADDRESS = /(?:#{H16}:){6}#{LS32}|::(?:#{H16}:){5}#{LS32}|(?:#{H16})?::(?:#{H16}:){4}#{LS32}|(?:(?:#{H16}:){0,1}#{H16})?::(?:#{H16}:){3}#{LS32}|(?:(?:#{H16}:){0,2}#{H16})?::(?:#{H16}:){2}#{LS32}|(?:(?:#{H16}:){0,3}#{H16})?::(?:#{H16}:){1}#{LS32}|(?:(?:#{H16}:){0,4}#{H16})?::#{LS32}|(?:(?:#{H16}:){0,5}#{H16})?::#{H16}|(?:(?:#{H16}:){0,6}#{H16})?::/.freeze

      IPV_FUTURE = /v\h+\.(?:#{UNRESERVED}|#{SUB_DELIMS}|:)+/.freeze
      IP_LITERAL = /\[(?:#{IPV6_ADDRESS}|#{IPV_FUTURE})\]/.freeze

      PORT = /\d*/.freeze
      REG_NAME = /(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS})*/.freeze
      HOST = /(?:#{IP_LITERAL}|#{IPV4_ADDRESS}|#{REG_NAME})/.freeze
      USERINFO = /(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|:)*/.freeze
      AUTHORITY = /(?:#{USERINFO}@)?#{HOST}(?::#{PORT})?/.freeze

      SCHEME = /[a-zA-Z][a-zA-Z\d+.-]*/.freeze

      HIER_PART = /(?:(?:\/\/#{AUTHORITY}#{PATH_ABEMPTY})|#{PATH_ABSOLUTE}|#{PATH_ROOTLESS})?/.freeze

      URI = /#{SCHEME}:#{HIER_PART}(?:\?#{QUERY})?(?:##{FRAGMENT})?/.freeze

      # ABSOLUTE_URI = /#{SCHEME}:#{HIER_PART}(?:\?#{QUERY})?/.freeze

      RELATIVE_PART = /(?:(?:\/\/#{AUTHORITY}#{PATH_ABEMPTY})|#{PATH_ABSOLUTE}|#{PATH_NOSCHEME})?/.freeze
      RELATIVE_REF = /#{RELATIVE_PART}(?:\?#{QUERY})?(?:##{FRAGMENT})?/.freeze
      URI_REFERENCE = /#{URI}|#{RELATIVE_REF}/.freeze

      REGEX = /\A#{URI}\z/.freeze

      def call(data)
        return if REGEX.match?(data.value)

        raise FormatError, "#{data} is not a valid URI"
      end
    end
  end
end
