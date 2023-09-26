# frozen_string_literal: true

require "delegate"

module JSONSkooma
  class JSONNode < SimpleDelegator
    extend Memoizable

    attr_reader :parent, :root, :key, :type

    def initialize(value, key: nil, parent: nil, item_class: JSONNode, **item_params)
      @key = key
      @parent = parent
      @root = parent&.root || self
      @item_class = item_class
      @item_params = item_params
      @type, data = parse_value(value)

      super(data)
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
      case type
      when "array"
        map(&:value)
      when "object"
        transform_values(&:value)
      else
        __getobj__
      end
    end
    memoize :value

    def path
      result = []
      each_parent { |node| result.unshift(node.key) }
      JSONPointer.new(result)
    end
    memoize :path

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
      value.map { |k, v| [k.to_s, @item_class.new(v, key: k.to_s, parent: self, **@item_params)] }.to_h
    end
  end
end
