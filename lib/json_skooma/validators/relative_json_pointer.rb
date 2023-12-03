# frozen_string_literal: true

module JSONSkooma
  module Validators
    class RelativeJSONPointer < Base
      self.key = "relative-json-pointer"

      nn_int = /0|[1-9][0-9]*/
      index = /[+-]#{nn_int}/
      relative_json_pointer = /(#{nn_int}(#{index})?#{JSONPointer::JSON_POINTER})|(#{nn_int}#)/
      REGEXP = /\A#{relative_json_pointer}\z/

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
