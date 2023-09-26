# frozen_string_literal: true

module JSONSkooma
  module Validators
    class FormatError < StandardError; end

    class << self
      attr_accessor :validators

      def register(name, validator)
        validators[name] = validator
      end
    end

    self.validators = {}
  end
end
