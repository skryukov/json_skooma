# frozen_string_literal: true

module JSONSkooma
  module Validators
    class DateTime < Base
      DATE_REGEXP = /(?<Y>\d{4})-(?<M>\d{2})-(?<D>\d{2})/
      PARTIAL_TIME = /(?<h>[01]\d|2[0-3]):(?<m>[0-5]\d):(?<s>[0-5]\d|60)(?<f>\.\d+)?/
      TIME_OFFSET = /[Zz]|(?<on>[+-])(?<oh>[01]\d|2[0-3]):(?<om>[0-5]\d)/
      FULL_TIME = /#{PARTIAL_TIME}#{TIME_OFFSET}/

      REGEXP = /\A(?<date>#{DATE_REGEXP})[Tt](?<time>#{FULL_TIME})\z/

      def call(data)
        match = REGEXP.match(data)
        raise FormatError, "must be a valid RFC 3339 date string" if match.nil?

        Date.call(match[:date])
        Time.call(match[:time])
      rescue FormatError
        raise FormatError, "must be a valid RFC 3339 date string"
      end
    end
  end
end
