# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Email < Base
      ATOM = /[a-zA-Z0-9!#$%&'*+\-\/=?^_`{|}~]+/
      DOT_STRING = /#{ATOM}(\.#{ATOM})*/
      QUOTED_PAIR_SMTP = /\x5C[\x20-\x7E]/
      QTEXT_SMTP = /[\x20-\x21\x23-\x5B\x5D-\x7E]/
      Q_CONTENT_SMTP = /#{QTEXT_SMTP}|#{QUOTED_PAIR_SMTP}/
      QUOTED_STRING = /"(#{Q_CONTENT_SMTP})*"/
      LOCAL_PART = /#{DOT_STRING}|#{QUOTED_STRING}/
      LET_DIG = /[a-zA-Z0-9]/
      LDH_STR = /[a-zA-Z0-9-]*#{LET_DIG}/
      SUB_DOMAIN = /#{LET_DIG}(#{LDH_STR})?/
      DOMAIN = /#{SUB_DOMAIN}(\.#{SUB_DOMAIN})*/
      IPV4 = /((25[0-5]|(2[0-4]|1\d|[1-9])?\d)\.?\b){4}/
      IPV6_FULL = /IPv6:\h{1,4}(:\h{1,4}){7}/
      IPV6_COMP = /IPv6:(\h{1,4}(:\h{1,4}){0,5})?::(\h{1,4}(:\h{1,4}){0,5})?/
      IPV6V4_FULL = /IPv6:\h{1,4}(:\h{1,4}){5}:\d{1,3}(\.\d{1,3}){3}/
      IPV6V4_COMP = /IPv6:(\h{1,4}(:\h{1,4}){0,3})?::(\h{1,4}(:\h{1,4}){0,3}:)?\d{1,3}(\.\d{1,3}){3}/
      IPV6 = /#{IPV6_FULL}|#{IPV6_COMP}|#{IPV6V4_FULL}|#{IPV6V4_COMP}/
      GENERAL_ADDRESS = /#{LDH_STR}:[\x21-\x5A\x5E-\x7E]+/
      ADDRESS_LITERAL = /\[(#{IPV4}|#{IPV6}|#{GENERAL_ADDRESS})\]/
      MAILBOX = /#{LOCAL_PART}@(#{DOMAIN}|#{ADDRESS_LITERAL})/

      REGEXP = /\A#{MAILBOX}\z/

      def call(data)
        return if REGEXP.match?(data)

        raise FormatError, "#{data} is not a valid email"
      end
    end
  end
end
