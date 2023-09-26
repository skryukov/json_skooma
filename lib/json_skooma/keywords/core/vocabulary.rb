# frozen_string_literal: true

module JSONSkooma
  module Keywords
    module Core
      class Vocabulary < Base
        self.key = "$vocabulary"
        self.static = true

        def initialize(parent_schema, value)
          super

          return unless parent_schema.is_a?(Metaschema)

          core_vocab_uri = parent_schema.core_vocabulary&.uri.to_s
          if core_vocab_uri.empty? || !value[core_vocab_uri]
            raise Error, "The `$vocabulary` keyword must list the core vocabulary with a value of true"
          end

          value.each do |vocabulary_uri, vocabulary_required|
            uri = URI.parse(vocabulary_uri)

            vocabulary = parent_schema.registry.vocabulary(uri)
            parent_schema.kw_classes.merge!(vocabulary.kw_classes)
          rescue RegistryError
            if vocabulary_required
              raise Error, "The metaschema requires an unrecognized vocabulary #{vocabulary_uri}"
            end
          end
        end
      end
    end
  end
end
