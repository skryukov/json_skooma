# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Date < Base
      REGEXP = /\A#{DateTime::DATE_REGEXP}\z/

      def call(data)
        match = REGEXP.match(data)
        raise FormatError, "must be a valid RFC 3339 date string" if match.nil?

        ::Date.new(match[:Y].to_i, match[:M].to_i, match[:D].to_i)
      rescue ::Date::Error
        raise FormatError, "must be a valid RFC 3339 date string"
      end
    end
  end
end
