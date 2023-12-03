# frozen_string_literal: true

module JSONSkooma
  module Validators
    class UriTemplate < Base
      self.key = "uri-template"

      pct = /%\h\h/
      var_char = /[A-Za-z\d_]|(#{pct})/
      var_name = /#{var_char}(\.?#{var_char})*/
      mod4 = /(:[1-9]\d{0,3}|(\*)?)/
      var_spec = /#{var_name}(#{mod4})?/
      var_list = /#{var_spec}(,#{var_spec})*/
      operator = /[+#.\/;?&=,!@|]/
      expression = /\{#{operator}?#{var_list}\}/
      literals = /[^\x00-\x20\x7F"'%<>\\^`{|}]/
      uri_template = /((#{literals})|(#{expression}))*/

      REGEXP = /\A#{uri_template}\z/

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
