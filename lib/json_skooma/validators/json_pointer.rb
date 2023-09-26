# frozen_string_literal: true

module JSONSkooma
  module Validators
    class JSONPointer < Base
      ESC = /~[01]/
      UNESC = /[\u0000-\u002E\u0030-\u007d\u007F-\u{10FFFF}]/
      TOKEN = /(#{ESC}|#{UNESC})*/
      JSON_POINTER = /(\/#{TOKEN})*/
      REGEXP = /\A#{JSON_POINTER}\z/

      def call(data)
        return if REGEXP.match?(data)

        raise FormatError, "#{data} is not a valid JSON pointer"
      end
    end
  end
end
