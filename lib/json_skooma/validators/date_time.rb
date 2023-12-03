# frozen_string_literal: true

module JSONSkooma
  module Validators
    class DateTime < Base
      self.key = "date-time"

      DATE_REGEXP = /(?<Y>\d{4})-(?<M>\d{2})-(?<D>\d{2})/
      partial_time = /(?<h>[01]\d|2[0-3]):(?<m>[0-5]\d):(?<s>[0-5]\d|60)(?<f>\.\d+)?/
      time_offset = /[Zz]|(?<on>[+-])(?<oh>[01]\d|2[0-3]):(?<om>[0-5]\d)/
      FULL_TIME = /#{partial_time}#{time_offset}/

      REGEXP = /\A(?<date>#{DATE_REGEXP})[Tt](?<time>#{FULL_TIME})\z/

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
