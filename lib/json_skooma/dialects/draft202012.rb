# frozen_string_literal: true

module JSONSkooma
  module Dialects
    module Draft202012
      class << self
        def call(registry, assert_formats: false)
          registry.add_source(
            "https://json-schema.org/draft/2020-12/",
            Sources::Local.new(File.join(DATA_DIR, "draft-2020-12").to_s, suffix: ".json")
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2020-12/vocab/core",
            Keywords::Core::Schema,
            Keywords::Core::Vocabulary,
            Keywords::Core::Id,
            Keywords::Core::Ref,
            Keywords::Core::Anchor,
            Keywords::Core::DynamicRef,
            Keywords::Core::DynamicAnchor,
            Keywords::Core::Defs,
            Keywords::Core::Comment
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2020-12/vocab/applicator",
            Keywords::Applicator::AllOf,
            Keywords::Applicator::AnyOf,
            Keywords::Applicator::OneOf,
            Keywords::Applicator::Not,
            Keywords::Applicator::If,
            Keywords::Applicator::Then,
            Keywords::Applicator::Else,
            Keywords::Applicator::DependentSchemas,
            Keywords::Applicator::PrefixItems,
            Keywords::Applicator::Items,
            Keywords::Applicator::Contains,
            Keywords::Applicator::Properties,
            Keywords::Applicator::PatternProperties,
            Keywords::Applicator::AdditionalProperties,
            Keywords::Applicator::PropertyNames
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2020-12/vocab/unevaluated",
            Keywords::Unevaluated::UnevaluatedItems,
            Keywords::Unevaluated::UnevaluatedProperties
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2020-12/vocab/validation",
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
            "https://json-schema.org/draft/2020-12/vocab/format-annotation",
            Keywords::FormatAnnotation::Format
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2020-12/vocab/format-assertion",
            Keywords::FormatAnnotation::Format
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2020-12/vocab/meta-data",
            Keywords::MetaData::Title,
            Keywords::MetaData::Description,
            Keywords::MetaData::Default,
            Keywords::MetaData::Deprecated,
            Keywords::MetaData::ReadOnly,
            Keywords::MetaData::WriteOnly,
            Keywords::MetaData::Examples
          )

          registry.add_vocabulary(
            "https://json-schema.org/draft/2020-12/vocab/content",
            Keywords::Content::ContentMediaType,
            Keywords::Content::ContentEncoding,
            Keywords::Content::ContentSchema
          )

          registry.add_metaschema(
            "https://json-schema.org/draft/2020-12/schema",
            "https://json-schema.org/draft/2020-12/vocab/core",
            "https://json-schema.org/draft/2020-12/vocab/applicator",
            "https://json-schema.org/draft/2020-12/vocab/unevaluated",
            "https://json-schema.org/draft/2020-12/vocab/validation",
            "https://json-schema.org/draft/2020-12/vocab/format-annotation",
            "https://json-schema.org/draft/2020-12/vocab/meta-data",
            "https://json-schema.org/draft/2020-12/vocab/content"
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
