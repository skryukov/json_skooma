# frozen_string_literal: true

require "regexp_parser"

module JSONSkooma
  module Validators
    class Regex < Base
      self.key = "regex"

      def call
        Regexp::Parser.parse(instance)
      rescue Regexp::Scanner::ScannerError => e
        failure!(message: e.message)
      end
    end
  end
end
