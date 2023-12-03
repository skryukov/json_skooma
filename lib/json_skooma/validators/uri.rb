# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Uri < Base
      self.key = "uri"

      SUB_DELIMS = "[!$&'()*+,;=]"
      UNRESERVED = "[A-Za-z\\d\\-._~]"
      PCT_ENCODED = "%\\h{2}"
      pchar = "(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|[:@])"
      fragment = "(?:#{pchar}|[?\\/])*"
      query = fragment

      segment = "#{pchar}*"
      segment_nz = "#{pchar}+"
      segment_nz_nc = "(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|@)+"

      path_abempty = "(?:\\/#{segment})*"
      path_absolute = "\\/(?:#{segment_nz}(?:/#{segment})*)?"
      path_noscheme = "#{segment_nz_nc}(?:\\/#{segment})*"
      path_rootless = "#{segment_nz}(?:\\/#{segment})*"

      ipv_future = "v\\h+\\.(?:#{UNRESERVED}|#{SUB_DELIMS}|:)+"
      IP_LITERAL = "\\[(?:#{Ipv6::IPV6_ADDRESS}|#{ipv_future})\\]"

      PORT = "\\d*"
      reg_name = "(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS})*"
      host = "(?:#{IP_LITERAL}|#{Ipv4::IPV4_ADDRESS}|#{reg_name})"
      userinfo = "(?:#{UNRESERVED}|#{PCT_ENCODED}|#{SUB_DELIMS}|:)*"
      authority = "(?:#{userinfo}@)?#{host}(?::#{PORT})?"

      SCHEME = "[a-zA-Z][a-zA-Z\\d+.-]*"

      hier_part = "(?:(?:\\/\\/#{authority}#{path_abempty})|#{path_absolute}|#{path_rootless})?"

      URI = "#{SCHEME}:#{hier_part}(?:\\?#{query})?(?:##{fragment})?"

      relative_part = "(?:(?:\\/\\/#{authority}#{path_abempty})|#{path_absolute}|#{path_noscheme})?"
      relative_ref = "#{relative_part}(?:\\?#{query})?(?:##{fragment})?"
      URI_REFERENCE = "(?:#{URI}|#{relative_ref})"

      REGEXP = /\A#{URI}\z/.freeze

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
