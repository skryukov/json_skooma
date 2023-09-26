# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Iri < Base
      UCSCHAR = /[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF\u{10000}-\u{1FFFD}]/.freeze
      IPRIVATE = /[\uE000-\uF8FF\u{F0000}-\u{FFFFD}\u{10000}-\u{1FFFD}\u{20000}-\u{2FFFD}\u{30000}-\u{3FFFD}\u{40000}-\u{4FFFD}\u{50000}-\u{5FFFD}\u{60000}-\u{6FFFD}\u{70000}-\u{7FFFD}\u{80000}-\u{8FFFD}\u{90000}-\u{9FFFD}\u{A0000}-\u{AFFFD}\u{B0000}-\u{BFFFD}\u{C0000}-\u{CFFFD}\u{D0000}-\u{DFFFD}\u{E1000}-\u{EFFFD}]/.freeze
      IUNRESERVED = /#{Uri::UNRESERVED}|#{UCSCHAR}/.freeze

      IPCHAR = /#{IUNRESERVED}|#{Uri::PCT_ENCODED}|#{Uri::SUB_DELIMS}|[:@]/.freeze

      IQUERY = /(?:#{IPCHAR}|#{IPRIVATE}|[?\/])*/.freeze
      IFRAGMENT = /(?:#{IPCHAR}|[?\/])*/.freeze

      ISEGMENT = /#{IPCHAR}*/.freeze
      ISEGMENT_NZ = /#{IPCHAR}+/.freeze
      ISEGMENT_NZ_NC = /(?:#{IUNRESERVED}|#{Uri::PCT_ENCODED}|#{Uri::SUB_DELIMS}|@)+/.freeze

      IPATH_ABEMPTY = /(?:\/#{ISEGMENT})*/.freeze
      IPATH_ABSOLUTE = /\/(?:#{ISEGMENT_NZ}(?:\/#{ISEGMENT})*)?/.freeze
      IPATH_NOSCHEME = /#{ISEGMENT_NZ_NC}(?:\/#{ISEGMENT})*/.freeze
      IPATH_ROOTLESS = /#{ISEGMENT_NZ}(?:\/#{ISEGMENT})*/.freeze
      IPATH_OLD = /#{IPATH_ABEMPTY}|#{IPATH_ABSOLUTE}|#{IPATH_NOSCHEME}|#{IPATH_ROOTLESS}|/.freeze

      IREG_NAME = /(?:#{IUNRESERVED}|#{Uri::PCT_ENCODED}|#{Uri::SUB_DELIMS})*/.freeze
      IHOST = /#{Uri::IP_LITERAL}|#{Uri::IPV4_ADDRESS}|#{IREG_NAME}/.freeze
      IUSERINFO = /(?:#{IUNRESERVED}|#{Uri::PCT_ENCODED}|#{Uri::SUB_DELIMS}|:)*/.freeze
      IAUTHORITY = /(?:#{IUSERINFO}@)?#{IHOST}(?::#{Uri::PORT})?/.freeze

      IHIER_PART = /(?:\/\/#{IAUTHORITY}#{IPATH_ABEMPTY})|#{IPATH_ABSOLUTE}|#{IPATH_ROOTLESS}|/.freeze

      IRI = /#{Uri::SCHEME}:#{IHIER_PART}(?:\?#{IQUERY})?(?:##{IFRAGMENT})?/.freeze

      IRELATIVE_PATH = /(?:\/\/#{IAUTHORITY}#{IPATH_ABEMPTY})|#{IPATH_ABSOLUTE}|#{IPATH_NOSCHEME}|/
      IRELATIVE_REF = /#{IRELATIVE_PATH}(?:\?#{IQUERY})?(?:##{IFRAGMENT})?/.freeze
      IRI_REFERENCE = /#{IRI}|#{IRELATIVE_REF}/.freeze

      REGEX = /\A#{IRI}\z/.freeze

      def call(data)
        return if REGEX.match?(data.value)

        raise FormatError, "#{data} is not a valid IRI"
      end
    end
  end
end
