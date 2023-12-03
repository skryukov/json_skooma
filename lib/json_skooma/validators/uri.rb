# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Uri < Base
      self.key = "uri"

      SUB_DELIMS = /[!$&'()*+,;=]/.freeze
      UNRESERVED = /[A-Za-z\d\-._~]/.freeze
      PCT_ENCODED = /%\h{2}/.freeze
      pchar = /(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|[:@])/.freeze
      fragment = /(?:#{pchar}|[?\/])*/.freeze
      query = fragment

      segment = /#{pchar}*/.freeze
      segment_nz = /#{pchar}+/.freeze
      segment_nz_nc = /(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|@)+/.freeze

      path_abempty = /(?:\/#{segment})*/.freeze
      path_absolute = /\/(?:#{segment_nz}(?:\/#{segment})*)?/.freeze
      path_noscheme = /#{segment_nz_nc}(?:\/#{segment})*/.freeze
      path_rootless = /#{segment_nz}(?:\/#{segment})*/.freeze

      ipv_future = /v\h+\.(?:#{UNRESERVED}|#{SUB_DELIMS}|:)+/.freeze
      IP_LITERAL = /\[(?:#{Ipv6::IPV6_ADDRESS}|#{ipv_future})\]/.freeze

      PORT = /\d*/.freeze
      reg_name = /(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS})*/.freeze
      host = /(?:#{IP_LITERAL}|#{Ipv4::IPV4_ADDRESS}|#{reg_name})/.freeze
      userinfo = /(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|:)*/.freeze
      authority = /(?:#{userinfo}@)?#{host}(?::#{PORT})?/.freeze

      SCHEME = /[a-zA-Z][a-zA-Z\d+.-]*/.freeze

      hier_part = /(?:(?:\/\/#{authority}#{path_abempty})|#{path_absolute}|#{path_rootless})?/.freeze

      URI = /#{SCHEME}:#{hier_part}(?:\?#{query})?(?:##{fragment})?/.freeze

      relative_part = /(?:(?:\/\/#{authority}#{path_abempty})|#{path_absolute}|#{path_noscheme})?/.freeze
      relative_ref = /#{relative_part}(?:\?#{query})?(?:##{fragment})?/.freeze
      URI_REFERENCE = /#{URI}|#{relative_ref}/.freeze

      REGEXP = /\A#{URI}\z/.freeze

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
