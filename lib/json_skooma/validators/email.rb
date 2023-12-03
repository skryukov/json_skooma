# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Email < Base
      self.key = "email"

      atom = /[a-zA-Z0-9!#$%&'*+\-\/=?^_`{|}~]+/
      dot_string = /#{atom}(\.#{atom})*/
      QUOTED_PAIR_SMTP = /\x5C[\x20-\x7E]/
      qtext_smtp = /[\x20-\x21\x23-\x5B\x5D-\x7E]/
      q_content_smtp = /#{qtext_smtp}|#{QUOTED_PAIR_SMTP}/
      quoted_string = /"(#{q_content_smtp})*"/
      local_part = /#{dot_string}|#{quoted_string}/
      let_dig = /[a-zA-Z0-9]/
      ldh_str = /[a-zA-Z0-9-]*#{let_dig}/
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
