# frozen_string_literal: true

module JSONSkooma
  module Validators
    class UriTemplate < Base
      PCT = /%\h\h/
      VAR_CHAR = /[A-Za-z\d_]|(#{PCT})/
      VAR_NAME = /#{VAR_CHAR}(\.?#{VAR_CHAR})*/
      MOD4 = /(:[1-9]\d{0,3}|(\*)?)/
      VAR_SPEC = /#{VAR_NAME}(#{MOD4})?/
      VAR_LIST = /#{VAR_SPEC}(,#{VAR_SPEC})*/
      OPERATOR = /[+#.\/;?&=,!@|]/
      EXPRESSION = /\{#{OPERATOR}?#{VAR_LIST}\}/
      LITERALS = /[^\x00-\x20\x7F"'%<>\\^`{|}]/
      URI_TEMPLATE = /((#{LITERALS})|(#{EXPRESSION}))*/

      REGEXP = /\A#{URI_TEMPLATE}\z/

      def call(data)
        return if REGEXP.match?(data)

        raise FormatError, "#{data} is not a valid URI template"
      end
    end
  end
end
