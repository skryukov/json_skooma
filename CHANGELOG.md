# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog],
and this project adheres to [Semantic Versioning].

## [Unreleased]

### Fixed

- Fix `$dynamicAnchor` boolean evaluation. ([@skryukov])

## [0.2.1] - 2023-12-03

### Fixed

- Make `unevaluated*` keyword respect reference keywords. ([@skryukov])
- Fix `:basic` output. ([@skryukov])

## [0.2.0] - 2023-10-23

### Added

- Add JSON Schema evaluation against a reference. ([@skryukov])

### Changed

- Optimized JSON Schema evaluation. ([@skryukov])

### Fixed

- Fix compatibility issues for Ruby < 3.1 and JRuby. ([@skryukov])
- Fix Zeitwerk eager loading. ([@skryukov])

## [0.1.0] - 2023-09-27

### Added

- Initial implementation. ([@skryukov])

[@skryukov]: https://github.com/skryukov

[Unreleased]: https://github.com/skryukov/json_skooma/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/skryukov/json_skooma/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/skryukov/json_skooma/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/skryukov/json_skooma/commits/v0.1.0

[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
