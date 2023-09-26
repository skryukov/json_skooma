# frozen_string_literal: true

module JSONSkooma
  module Validators
    class RelativeJSONPointer < Base
      NN_INT = /0|[1-9][0-9]*/
      INDEX = /[+-]#{NN_INT}/
      RELATIVE_JSON_POINTER = /(#{NN_INT}(#{INDEX})?#{JSONPointer::JSON_POINTER})|(#{NN_INT}#)/
      REGEXP = /\A#{RELATIVE_JSON_POINTER}\z/

      def call(data)
        return if REGEXP.match?(data)

        raise FormatError, "#{data} is not a valid JSON pointer"
      end
    end
  end
end
