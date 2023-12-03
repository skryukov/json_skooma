# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Uuid < Base
      self.key = "uuid"

      REGEXP = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
