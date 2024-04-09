# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Base
      class << self
        attr_reader :instance_types
        attr_writer :key

        def key
          @key or raise "Key must be defined"
        end

        def instance_types=(value)
          @instance_types = Array(value)
        end

        def assert?(instance)
          instance_types.include?(instance.type)
        end

        def call(instance)
          new(instance).call
        end

        def inherited(subclass)
          subclass.instance_types = "string"
        end
      end

      attr_reader :instance

      def initialize(instance)
        @instance = instance
      end

      def call
        raise NotImplementedError, "must be implemented by subclass"
      end

      def failure!(**options)
        raise FormatError, I18n.t(
          self.class.key,
          scope: [:validation_errors],
          # TODO: add i18n cascade options
          default: [],
          instance: instance,
          **options
        ), []
      end
    end
  end
end
