# frozen_string_literal: true

module JSONSkooma
  module Validators
    class FormatError < StandardError; end

    class << self
      attr_accessor :validators

      def register(*attrs)
        validator =
          if attrs.size == 1
            attrs[0]
          else
            warn "#{attrs[1]} – Module validators deprecated in favor of class-based validators and will be removed in JSONSkooma 0.4.0"

            Class.new(Base) do
              self.key = attrs.shift

              define_method(:call) do
                attrs.shift.call(instance)
              end
            end
          end

        validators[validator.key] = validator
        validator.key
      end
    end

    self.validators = {}
  end
end
