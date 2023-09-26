# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Duration < Base
      SECOND = /\d+S/
      MINUTE = /\d+M#{SECOND}?/
      HOUR = /\d+H#{MINUTE}?/
      DAY = /\d+D/
      WEEK = /\d+W/
      MONTH = /\d+M#{DAY}?/
      YEAR = /\d+Y#{MONTH}?/
      TIME = /T(#{HOUR}|#{MINUTE}|#{SECOND})/
      DATE = /(#{DAY}|#{MONTH}|#{YEAR})#{TIME}?/
      DURATION = /P(#{DATE}|#{TIME}|#{WEEK})/
      REGEXP = /\A#{DURATION}\z/

      def call(data)
        return if REGEXP.match?(data)

        raise FormatError, "#{data} is not a valid duration"
      end
    end
  end
end
