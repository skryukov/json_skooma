# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Time < Base
      REGEXP = /\A#{DateTime::FULL_TIME}\z/

      def call(data)
        match = REGEXP.match(data)

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
          time = time % (60 * 24)
        end
        leap_time = 23 * 60 + 59
        time == leap_time
      end
    end
  end
end
