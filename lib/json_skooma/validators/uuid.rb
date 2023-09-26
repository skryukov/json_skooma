# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Uuid < Base
      REGEXP = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/

      def call(data)
        return if REGEXP.match?(data)

        raise FormatError, "#{data} is not a valid UUID"
      end
    end
  end
end
