# frozen_string_literal: true

module JSONSkooma
  module Validators
    class IdnEmail < Base
      UTF8_NON_ASCII = /[\u0080-\u{10FFFF}]/
      ATOM = /([a-zA-Z0-9!#$%&'*+\-\/=?^_`{|}~]|#{UTF8_NON_ASCII})+/
      DOT_STRING = /#{ATOM}(\.#{ATOM})*/
      QTEXT_SMTP = /[\x20-\x21\x23-\x5B\x5D-\x7E]|#{UTF8_NON_ASCII}/
      Q_CONTENT_SMTP = /#{QTEXT_SMTP}|#{Email::QUOTED_PAIR_SMTP}/
      QUOTED_STRING = /"(#{Q_CONTENT_SMTP})*"/
      LOCAL_PART = /#{DOT_STRING}|#{QUOTED_STRING}/
      LET_DIG = /[a-zA-Z0-9\u0080-\u{10FFFF}]/
      LDH_STR = /[a-zA-Z0-9\u0080-\u{10FFFF}-]*#{LET_DIG}/
      SUB_DOMAIN = /#{LET_DIG}(#{LDH_STR})?/
      DOMAIN = /#{SUB_DOMAIN}(\.#{SUB_DOMAIN})*/
      GENERAL_ADDRESS = /#{LDH_STR}:[\x21-\x5A\x5E-\x7E]+/
      ADDRESS_LITERAL = /\[(#{Email::IPV4}|#{Email::IPV6}|#{GENERAL_ADDRESS})\]/
      MAILBOX = /#{LOCAL_PART}@(#{DOMAIN}|#{ADDRESS_LITERAL})/

      REGEXP = /\A#{MAILBOX}\z/

      def call(data)
        return if REGEXP.match?(data.value)

        raise FormatError, "#{data} is not a valid IDN email"
      end
    end
  end
end
