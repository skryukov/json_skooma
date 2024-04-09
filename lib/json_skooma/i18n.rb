# frozen_string_literal: true

require "i18n"

module JSONSkooma
  module I18n
    DEFAULT_SCOPE = [:json_skooma].freeze
    DEFAULT_VALUES = YAML.load_file(File.expand_path("../../locale/en.yml", __FILE__))["en"]["json_skooma"]["errors"].freeze

    class << self
      def translate(key, *args, **options)
        lookup_key = (options[:default].last || key).to_s
        options[:default] = (options[:default] || []) << DEFAULT_VALUES[lookup_key]
        options[:scope] = options[:scope] ? Array(options[:scope]).unshift(DEFAULT_SCOPE) : DEFAULT_SCOPE
        ::I18n.translate(key, *args, **options)
      end
      alias_method :t, :translate
    end
  end
end

I18n.enforce_available_locales = false if I18n.respond_to?(:enforce_available_locales)
