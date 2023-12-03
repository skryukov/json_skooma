# frozen_string_literal: true

module JSONSkooma
  module Validators
    class IdnEmail < Base
      self.key = "idn-email"

      utf8_non_ascii = /[\u0080-\u{10FFFF}]/
      atom = /([a-zA-Z0-9!#$%&'*+\-\/=?^_`{|}~]|#{utf8_non_ascii})+/
      dot_string = /#{atom}(\.#{atom})*/
      qtext_smtp = /[\x20-\x21\x23-\x5B\x5D-\x7E]|#{utf8_non_ascii}/
      q_content_smtp = /#{qtext_smtp}|#{Email::QUOTED_PAIR_SMTP}/
      quoted_string = /"(#{q_content_smtp})*"/
      local_part = /#{dot_string}|#{quoted_string}/
      let_dig = /[a-zA-Z0-9\u0080-\u{10FFFF}]/
      ldh_str = /[a-zA-Z0-9\u0080-\u{10FFFF}-]*#{let_dig}/
      sub_domain = /#{let_dig}(#{ldh_str})?/
      domain = /#{sub_domain}(\.#{sub_domain})*/
      general_address = /#{ldh_str}:[\x21-\x5A\x5E-\x7E]+/
      address_literal = /\[(#{Ipv4::IPV4_ADDRESS}|IPv6:#{Ipv6::IPV6_ADDRESS}|#{general_address})\]/
      mailbox = /#{local_part}@(#{domain}|#{address_literal})/

      REGEXP = /\A#{mailbox}\z/

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
