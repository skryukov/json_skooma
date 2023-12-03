# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Hostname < Base
      self.key = "hostname"

      REGEXP = /\A(?=.{1,253}\.?\z)[a-z\d](?:[a-z\d-]{0,61}[a-z\d])?(?:\.[a-z\d](?:[a-z\d-]{0,61}[a-z\d])?)*\.?\z/i

      def call
        failure! unless REGEXP.match?(instance)
      end
    end
  end
end
