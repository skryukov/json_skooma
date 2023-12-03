# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Date < Base
      self.key = "date"

      DATE_REGEXP_STRING = "(?<Y>\\d{4})-(?<M>\\d{2})-(?<D>\\d{2})"
      REGEXP = /\A#{DATE_REGEXP_STRING}\z/

      def call
        match = REGEXP.match(instance)
        failure! if match.nil?

        ::Date.new(match[:Y].to_i, match[:M].to_i, match[:D].to_i)
      rescue ::Date::Error
        failure!
      end
    end
  end
end
