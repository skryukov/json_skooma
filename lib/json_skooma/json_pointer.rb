# frozen_string_literal: true

require "hana"
require "cgi"

module JSONSkooma
  class JSONPointer < Hana::Pointer
    extend Memoizable
    ESC_REGEX = /[\/^~]/.freeze
    ESC2 = {"^" => "^^", "~" => "~0", "/" => "~1"}.freeze
    ESCAPE_REGEX = /([^ a-zA-Z0-9_.\-~\/!$&'()*+,;=]+)/.freeze

    def self.new_root(path)
      return [""] if path == ""

      parts = ((path.include?("%") || path.include?("+")) ? CGI.unescape(path) : path).split(/(?<!\^)\//).each { |part|
        part.gsub!(/\^[\/^]|~[01]/) { |m| ESC[m] }
      }

      parts.push("") if path.end_with?("/")

      new(parts)
    end

    def initialize(path)
      if path.is_a?(Array)
        @path = path
      else
        super CGI.unescape(path)
      end
    end

    def child(key)
      self.class.new(@path.dup.push(key))
    end

    def <<(part)
      case part
      when Array
        @path.concat(part.map(&:to_s))
      when JSONPointer
        @path.concat(part.path)
      else
        @path << part.to_s
      end
      self
    end

    def to_s
      return "" if @path == []
      return "/" if @path == [""]

      "/" + @path.map(&method(:escape)).join("/")
    end

    memoize :to_s

    def ==(other)
      return super unless other.is_a?(self.class)
      other.path == path
    end

    protected

    attr_reader :path

    private

    def escape(part)
      string = part.gsub(ESC_REGEX) { |m| ESC2[m] }
      encoding = string.encoding
      string.b.gsub!(ESCAPE_REGEX) do |m|
        "%" + m.unpack("H2" * m.bytesize).join("%").upcase
      end
      string.tr!(" ", "+")
      string.force_encoding(encoding)
    end
  end
end
