# frozen_string_literal: true

module JSONSkooma
  module Validators
    class Base
      class << self
        attr_reader :instance_types

        def instance_types=(value)
          @instance_types = Array(value)
        end

        def assert?(instance)
          instance_types.include?(instance.type)
        end

        def call(instance)
          new.call(instance)
        end

        def inherited(subclass)
          subclass.instance_types = "string"
        end
      end

      def call(_instance)
        raise NotImplementedError, "must be implemented by subclass"
      end
    end
  end
end
