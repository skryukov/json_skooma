# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Iri < Base
      self.key = "iri"

      ucschar = /[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF\u{10000}-\u{1FFFD}]/.freeze
      iprivate = /[\uE000-\uF8FF\u{F0000}-\u{FFFFD}\u{10000}-\u{1FFFD}\u{20000}-\u{2FFFD}\u{30000}-\u{3FFFD}\u{40000}-\u{4FFFD}\u{50000}-\u{5FFFD}\u{60000}-\u{6FFFD}\u{70000}-\u{7FFFD}\u{80000}-\u{8FFFD}\u{90000}-\u{9FFFD}\u{A0000}-\u{AFFFD}\u{B0000}-\u{BFFFD}\u{C0000}-\u{CFFFD}\u{D0000}-\u{DFFFD}\u{E1000}-\u{EFFFD}]/.freeze
      iunreserved = /#{Uri::UNRESERVED}|#{ucschar}/.freeze

      ipchar = /#{iunreserved}|#{Uri::PCT_ENCODED}|#{Uri::SUB_DELIMS}|[:@]/.freeze

      iquery = /(?:#{ipchar}|#{iprivate}|[?\/])*/.freeze
      ifragment = /(?:#{ipchar}|[?\/])*/.freeze

      isegment = /#{ipchar}*/.freeze
      isegment_nz = /#{ipchar}+/.freeze
      isegment_nz_nc = /(?:#{iunreserved}|#{Uri::PCT_ENCODED}|#{Uri::SUB_DELIMS}|@)+/.freeze

      ipath_abempty = /(?:\/#{isegment})*/.freeze
      ipath_absolute = /\/(?:#{isegment_nz}(?:\/#{isegment})*)?/.freeze
      ipath_noscheme = /#{isegment_nz_nc}(?:\/#{isegment})*/.freeze
      ipath_rootless = /#{isegment_nz}(?:\/#{isegment})*/.freeze

      ireg_name = /(?:#{iunreserved}|#{Uri::PCT_ENCODED}|#{Uri::SUB_DELIMS})*/.freeze
      ihost = /#{Uri::IP_LITERAL}|#{Ipv4::IPV4_ADDRESS}|#{ireg_name}/.freeze
      iuserinfo = /(?:#{iunreserved}|#{Uri::PCT_ENCODED}|#{Uri::SUB_DELIMS}|:)*/.freeze
      iauthority = /(?:#{iuserinfo}@)?#{ihost}(?::#{Uri::PORT})?/.freeze

      ihier_part = /(?:\/\/#{iauthority}#{ipath_abempty})|#{ipath_absolute}|#{ipath_rootless}|/.freeze

      iri = /#{Uri::SCHEME}:#{ihier_part}(?:\?#{iquery})?(?:##{ifragment})?/.freeze

      irelative_path = /(?:\/\/#{iauthority}#{ipath_abempty})|#{ipath_absolute}|#{ipath_noscheme}|/
      irelative_ref = /#{irelative_path}(?:\?#{iquery})?(?:##{ifragment})?/.freeze
      IRI_REFERENCE = /#{iri}|#{irelative_ref}/.freeze

      REGEXP = /\A#{iri}\z/.freeze

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
