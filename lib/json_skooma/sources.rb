# frozen_string_literal: true

require "open-uri"
require "yaml"

module JSONSkooma
  module Sources
    class Error < JSONSkooma::Error; end

    class Base
      def initialize(base, suffix: nil)
        @base = base
        @suffix = suffix
      end

      def call(relative_path)
        YAML.safe_load(read(relative_path))
      rescue Psych::SyntaxError
        raise Error, "Could not parse file #{relative_path}"
      end

      private

      attr_reader :base, :suffix

      def read(path)
        raise "Not implemented"
      end
    end

    class Local < Base
      private

      def read(relative_path)
        path = File.expand_path(relative_path, base)
        path += suffix if suffix
        File.read(path)
      rescue Errno::ENOENT
        raise Error, "Could not find file #{path}"
      end
    end

    class Remote < Base
      private

      def read(relative_path)
        path = suffix ? relative_path + suffix : relative_path
        url = URI.join(base, path)
        URI.parse(url).open.read
      rescue OpenURI::HTTPError, SocketError
        raise Error, "Could not fetch #{url}"
      end
    end
  end
end
