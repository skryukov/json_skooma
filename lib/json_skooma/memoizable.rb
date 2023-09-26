# frozen_string_literal: true

module JSONSkooma
  module Memoizable
    def self.included(base)
      base.extend(Memoizable)
    end

    def memoize(method_name)
      this = respond_to?(:prepend) ? self : singleton_class
      var_name = "@memoized_#{method_name}"
      this.prepend(Module.new do
        define_method(method_name) do
          return instance_variable_get(var_name) if instance_variable_defined?(var_name)

          instance_variable_set(var_name, super())
        end
      end)
    end
  end
end
