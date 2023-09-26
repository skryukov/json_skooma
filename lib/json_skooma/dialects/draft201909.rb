# frozen_string_literal: true

module JSONSkooma
  module Dialects
    module Draft201909
      class << self
        def call(registry, assert_formats: false)
          registry.add_source(
            "https://json-schema.org/draft/2019-09/",
            Sources::Local.new(File.join(DATA_DIR, "draft-2019-09").to_s, suffix: ".json")
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2019-09/vocab/core",
            Keywords::Core::Schema,
            Keywords::Core::Vocabulary,
            Keywords::Core::Id,
            Keywords::Core::Ref,
            Keywords::Core::Anchor,
            Keywords::Draft201909::RecursiveRef,
            Keywords::Draft201909::RecursiveAnchor,
            Keywords::Core::Defs,
            Keywords::Core::Comment
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2019-09/vocab/applicator",
            Keywords::Applicator::AllOf,
            Keywords::Applicator::AnyOf,
            Keywords::Applicator::OneOf,
            Keywords::Applicator::Not,
            Keywords::Applicator::If,
            Keywords::Applicator::Then,
            Keywords::Applicator::Else,
            Keywords::Applicator::DependentSchemas,
            Keywords::Draft201909::Items,
            Keywords::Draft201909::AdditionalItems,
            Keywords::Draft201909::UnevaluatedItems,
            Keywords::Applicator::Contains,
            Keywords::Applicator::Properties,
            Keywords::Applicator::PatternProperties,
            Keywords::Applicator::AdditionalProperties,
            Keywords::Unevaluated::UnevaluatedProperties,
            Keywords::Applicator::PropertyNames
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2019-09/vocab/validation",
            Keywords::Validation::Type,
            Keywords::Validation::Enum,
            Keywords::Validation::Const,
            Keywords::Validation::MultipleOf,
            Keywords::Validation::Maximum,
            Keywords::Validation::ExclusiveMaximum,
            Keywords::Validation::Minimum,
            Keywords::Validation::ExclusiveMinimum,
            Keywords::Validation::MaxLength,
            Keywords::Validation::MinLength,
            Keywords::Validation::Pattern,
            Keywords::Validation::MaxItems,
            Keywords::Validation::MinItems,
            Keywords::Validation::UniqueItems,
            Keywords::Validation::MaxContains,
            Keywords::Validation::MinContains,
            Keywords::Validation::MaxProperties,
            Keywords::Validation::MinProperties,
            Keywords::Validation::Required,
            Keywords::Validation::DependentRequired
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2019-09/vocab/format",
            # todo: move to legacy
            Keywords::FormatAnnotation::Format
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2019-09/vocab/meta-data",
            Keywords::MetaData::Title,
            Keywords::MetaData::Description,
            Keywords::MetaData::Default,
            Keywords::MetaData::Deprecated,
            Keywords::MetaData::ReadOnly,
            Keywords::MetaData::WriteOnly,
            Keywords::MetaData::Examples
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2019-09/vocab/content",
            Keywords::Content::ContentMediaType,
            Keywords::Content::ContentEncoding,
            Keywords::Content::ContentSchema
          )

          registry.add_metaschema(
            "https://json-schema.org/draft/2019-09/schema",
            "https://json-schema.org/draft/2019-09/vocab/core",
            "https://json-schema.org/draft/2019-09/vocab/applicator",
            "https://json-schema.org/draft/2019-09/vocab/validation",
            "https://json-schema.org/draft/2019-09/vocab/format",
            "https://json-schema.org/draft/2019-09/vocab/meta-data",
            "https://json-schema.org/draft/2019-09/vocab/content"
          )

          if assert_formats
            registry.add_format("date-time", Validators::DateTime)
            registry.add_format("date", Validators::Date)
            registry.add_format("time", Validators::Time)
            registry.add_format("duration", Validators::Duration)

            registry.add_format("email", Validators::Email)
            registry.add_format("idn-email", Validators::IdnEmail)

            registry.add_format("hostname", Validators::Hostname)
            registry.add_format("idn-hostname", Validators::IdnHostname)

            registry.add_format("ipv4", Validators::Ipv4)
            registry.add_format("ipv6", Validators::Ipv6)

            registry.add_format("uri", Validators::Uri)
            registry.add_format("uri-reference", Validators::UriReference)
            registry.add_format("iri", Validators::Iri)
            registry.add_format("iri-reference", Validators::IriReference)
            registry.add_format("uuid", Validators::Uuid)

            registry.add_format("uri-template", Validators::UriTemplate)

            registry.add_format("json-pointer", Validators::JSONPointer)
            registry.add_format("relative-json-pointer", Validators::RelativeJSONPointer)

            registry.add_format("regex", Validators::Regex)
          end
        end
      end
    end
  end
end
