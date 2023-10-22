# frozen_string_literal: true

require "json"
require "zeitwerk"

require_relative "json_skooma/inflector"

loader = Zeitwerk::Loader.for_gem
loader.inflector = JSONSkooma::Inflector.new(__FILE__)
loader.setup

module JSONSkooma
  DATA_DIR = File.join(__dir__, "..", "data")

  class Error < StandardError; end

  class << self
    attr_accessor :dialects

    def register_dialect(version_key, dialect)
      dialects[version_key] = dialect
    end

    def create_registry(*schema_dialects, name: Registry::DEFAULT_NAME, assert_formats: false)
      registry = Registry.new(name: name)

      schema_dialects.each do |version_key|
        dialects.fetch(version_key).call(registry, assert_formats: assert_formats)
      end

      registry
    end
  end

  self.dialects = {}

  register_dialect("2019-09", Dialects::Draft201909)
  register_dialect("2020-12", Dialects::Draft202012)
end
