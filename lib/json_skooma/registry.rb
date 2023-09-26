# frozen_string_literal: true

module JSONSkooma
  class RegistryError < Error; end

  class Registry
    class << self
      attr_accessor :registries

      def [](key)
        return key if key.is_a?(Registry)

        raise RegistryError, "Registry `#{key}` not found" unless registries.key?(key)

        registries[key]
      end
    end

    self.registries = {}

    DEFAULT_NAME = "registry"

    def initialize(name: DEFAULT_NAME)
      @uri_sources = {}
      @vocabularies = {}
      @schema_cache = {}
      @enabled_formats = Set.new

      self.class.registries[name] = self
    end

    def add_format(key, validator = nil)
      JSONSkooma::Validators.register(key, validator) if validator
      raise RegistryError, "Format validator `#{key}` not found" unless Validators.validators.key?(key)

      @enabled_formats << key
    end

    def format_enabled?(key)
      @enabled_formats.include?(key)
    end

    def add_vocabulary(uri, *keywords)
      @vocabularies[uri.to_s] = Vocabulary.new(uri, *keywords)
    end

    def vocabulary(uri)
      @vocabularies[uri.to_s] or raise RegistryError, "vocabulary #{uri} not found"
    end

    def add_schema(uri, schema, cache_id: "default")
      @schema_cache[cache_id] ||= {}
      @schema_cache[cache_id][uri.to_s] = schema
    end

    def delete_schema(uri, cache_id: "default")
      @schema_cache[cache_id].delete(uri.to_s)
    end

    def schema(uri, metaschema_uri: nil, cache_id: "default", schema_class: JSONSchema, expected_class: JSONSchema)
      schema = @schema_cache.dig(cache_id, uri.to_s)
      return schema if schema

      base_uri = uri.dup.tap { |u| u.fragment = nil }
      schema = @schema_cache.dig(cache_id, base_uri.to_s) if uri.fragment

      if schema.nil?
        doc = load_json(base_uri)

        schema = schema_class.new(
          doc,
          registry: self,
          cache_id: cache_id,
          uri: base_uri,
          metaschema_uri: metaschema_uri
        )
        return @schema_cache.dig(cache_id, uri.to_s) if @schema_cache.dig(cache_id, uri.to_s)
      end
      schema = JSONPointer.new(uri.fragment).eval(schema) if uri.fragment
      return schema if schema.is_a?(expected_class)

      raise RegistryError, "The object referenced by #{uri} is not #{expected_class}"
    end

    def add_metaschema(uri, default_core_vocabulary_uri = nil, *default_vocabulary_uris)
      metaschema_doc = load_json(uri)
      default_core_vocabulary = vocabulary(default_core_vocabulary_uri) if default_core_vocabulary_uri
      default_vocabularies = default_vocabulary_uris.map { |vocabulary_uri| vocabulary(vocabulary_uri) }

      metaschema = Metaschema.new(
        metaschema_doc,
        default_core_vocabulary,
        *default_vocabularies,
        registry: self,
        uri: uri
      )

      return metaschema if metaschema.validate.valid?

      raise RegistryError, "The metaschema is invalid against its own metaschema #{metaschema_doc["$schema"]}"
    end

    def metaschema(uri)
      schema = @schema_cache.dig("__meta__", uri.to_s) || add_metaschema(uri.to_s)
      return schema if schema

      raise RegistryError, "The schema referenced by #{uri} is not a metaschema"
    end

    def add_source(uri, source)
      raise RegistryError, "uri must end with '/'" unless uri.end_with?("/")

      @uri_sources[uri] = source
    end

    private

    def load_json(uri)
      candidates = @uri_sources
        .select { |source_uri| uri.to_s.start_with?(source_uri) }
        .sort_by { |source_uri| -source_uri.length }

      raise RegistryError, "A source is not available for #{uri}" if candidates.empty?

      base_uri, candidate = candidates.first
      relative_path = uri.to_s.sub(base_uri, "")
      candidate.call(relative_path)
    end
  end
end
