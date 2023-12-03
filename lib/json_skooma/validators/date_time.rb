# frozen_string_literal: true

module JSONSkooma
  module Validators
    class DateTime < Base
      self.key = "date-time"

      REGEXP = /\A(?<date>#{Date::DATE_REGEXP_STRING})[Tt](?<time>#{Time::TIME_REGEXP_STRING})\z/

      def call
        match = REGEXP.match(instance)
        failure! if match.nil?

        Date.call(match[:date])
        Time.call(match[:time])
      rescue FormatError
        failure!
      end
    end
  end
end
