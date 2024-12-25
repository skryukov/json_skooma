# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in json_skooma.gemspec
gemspec

gem "rake", "~> 13.0"

gem "rspec", "~> 3.0"
gem "webmock"

gem "standard", "~> 1.35.0"

if defined?(JRUBY_VERSION)
  gem "jar-dependencies", "< 0.5" # see https://github.com/jruby/jruby/issues/8488
  gem "bigdecimal", "3.1.8" # see https://github.com/ruby/bigdecimal/issues/309
end
