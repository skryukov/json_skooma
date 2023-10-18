# frozen_string_literal: true

module JSONSkooma
  class Metaschema < JSONSchema
    attr_accessor :core_vocabulary, :default_vocabularies
    attr_reader :kw_classes

    def initialize(value, core_vocabulary, *default_vocabularies, **options)
      @core_vocabulary = core_vocabulary
      @default_vocabularies = default_vocabularies
      @kw_classes = {}
      super(value, cache_id: "__meta__", **options)
    end

    def kw_class(key)
      kw_classes[key] ||= Keywords::Unknown[key]
    end

    private

    def bootstrap(value)
      super

      kw = Keywords::Core::Vocabulary.new(self, value.fetch("$vocabulary") { default_vocabulary_urls })
      add_keyword(kw) if value.key?("$vocabulary")
    end

    def default_vocabulary_urls
      (default_vocabularies + [core_vocabulary]).filter_map(&:uri).map { |uri| [uri.to_s, true] }.to_h
    end
  end
end
