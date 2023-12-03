# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Duration < Base
      self.key = "duration"

      second = "\\d+S"
      minute = "\\d+M(?:#{second})?"
      hour = "\\d+H(?:#{minute})?"
      day = "\\d+D"
      week = "\\d+W"
      month = "\\d+M(?:#{day})?"
      year = "\\d+Y(?:#{month})?"
      time = "T(?:#{hour}|#{minute}|#{second})"
      date = "(?:#{day}|#{month}|#{year})(?:#{time})?"
      REGEXP = /\AP(?:#{date}|#{time}|#{week})\z/

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
