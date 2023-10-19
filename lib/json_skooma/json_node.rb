# frozen_string_literal: true

require "delegate"

module JSONSkooma
  class JSONNode < SimpleDelegator
    attr_reader :parent, :key, :type

    def initialize(value, key: nil, parent: nil, item_class: JSONNode, **item_params)
      @key = key
      @parent = parent
      @item_class = item_class
      @item_params = item_params
      @type, data = parse_value(value)

      super(data)
    end

    def root
      @root ||= parent&.root || self
    end

    def [](key)
      case type
      when "array"
        super(key.to_i)
      when "object"
        super(key.to_s)
      else
        raise Error, "Cannot get key #{key} from #{__getobj__.class} in #{path}"
      end
    end

    def value
      return @value if instance_variable_defined?(:@value)

      @value =
        case type
        when "array"
          map(&:value)
        when "object"
          transform_values(&:value)
        else
          __getobj__
        end
    end

    def path
      return @path if instance_variable_defined?(:@path)

      @path = @parent.nil? ? JSONPointer.new([]) : @parent.path.child(@key)
    end

    def ==(other)
      return super(other.__getobj__) if other.is_a?(self.class)
      super
    end

    def !=(other)
      return super(other.__getobj__) if other.is_a?(self.class)
      super
    end

    private

    def each_parent
      node = self

      while node.parent
        yield node
        node = node.parent
      end
    end

    def parse_value(value)
      case value
      when true, false
        ["boolean", value]
      when String
        ["string", value]
      when Integer, Float
        ["number", value]
      when nil
        ["null", value]
      when Hash
        ["object", map_object_value(value)]
      when Array
        ["array", map_array_value(value)]
      else
        raise Error, "Unknown JSON type: #{value.class}"
      end
    end

    def map_array_value(value)
      value.map.with_index { |v, i| @item_class.new(v, key: i.to_s, parent: self, **@item_params) }
    end

    def map_object_value(value)
      value.each_with_object({}) do |(k, v), h|
        h[k.to_s] = @item_class.new(v, key: k.to_s, parent: self, **@item_params)
      end
    end
  end
end
