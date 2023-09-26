# frozen_string_literal: true

require "regexp_parser"

module JSONSkooma
  module Validators
    class Regex < Base
      def call(data)
        Regexp::Parser.parse(data)
      rescue Regexp::Scanner::ScannerError => e
        raise FormatError, e.message
      end
    end
  end
end
