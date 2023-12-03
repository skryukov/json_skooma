# frozen_string_literal: true

require_relative "lib/json_skooma/version"

Gem::Specification.new do |spec|
  spec.name = "json_skooma"
  spec.version = JSONSkooma::VERSION
  spec.authors = ["Svyatoslav Kryukov"]
  spec.email = ["me@skryukov.dev"]

  spec.summary = "I bring some sugar for your JSONs."
  spec.description = "I bring some sugar for your JSONs."
  spec.homepage = "https://github.com/skryukov/json_skooma"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "documentation_uri" => "#{spec.homepage}/blob/main/README.md",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.glob("lib/**/*") + Dir.glob("data/**/{*.json,README.md}") + %w[README.md LICENSE.txt CHANGELOG.md]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "zeitwerk", "~> 2.6"
  spec.add_runtime_dependency "hana", "~> 1.3"
  spec.add_runtime_dependency "regexp_parser", "~> 2.0"
  spec.add_runtime_dependency "uri-idna", "~> 0.2"
  spec.add_runtime_dependency "i18n", "~> 1.9"
end
