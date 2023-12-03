# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Time < Base
      self.key = "time"

      partial_time = "(?<h>[01]\\d|2[0-3]):(?<m>[0-5]\\d):(?<s>[0-5]\\d|60)(?<f>\\.\\d+)?"
      time_offset = "(?:[Zz]|(?<on>[+-])(?<oh>[01]\\d|2[0-3]):(?<om>[0-5]\\d))"
      TIME_REGEXP_STRING = "#{partial_time}#{time_offset}"

      REGEXP = /\A#{TIME_REGEXP_STRING}\z/

      def call
        match = REGEXP.match(instance)

        if match.nil? || !valid_leap_seconds?(match)
          raise FormatError, "must be a valid RFC 3339 time string"
        end
      end

      private

      def valid_leap_seconds?(match)
        return true if match[:s].to_i != 60

        time = match[:h].to_i * 60 + match[:m].to_i
        if match[:on]
          sign = (match[:on] == "+") ? -1 : 1
          time += sign * (match[:oh].to_i * 60 + match[:om].to_i)
          time %= (60 * 24)
        end
        leap_time = 23 * 60 + 59
        time == leap_time
      end
    end
  end
end
