# frozen_string_literal: true

module JSONSkooma
  module Validators
    class JSONPointer < Base
      self.key = "json-pointer"

      esc = "~[01]"
      unesc = "[\\u0000-\\u002E\\u0030-\\u007d\\u007F-\\u{10FFFF}]"
      token = "(?:#{esc}|#{unesc})*"
      JSON_POINTER = "(?:\\/#{token})*"
      REGEXP = /\A#{JSON_POINTER}\z/

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
