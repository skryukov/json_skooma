# frozen_string_literal: true

module JSONSkooma
  class Result
    attr_writer :ref_schema

    attr_reader :children, :path, :relative_path, :schema, :instance, :parent, :annotation, :error, :key, :root

    def initialize(schema, instance, parent: nil, key: nil)
      @schema = schema
      @instance = instance
      @parent = parent
      @root = parent&.root || self
      @key = key
      @children = {}
      @valid = true
      if parent.nil?
        @path = JSONPointer.new([])
        @relative_path = JSONPointer.new([])
      else
        @path = parent.path.child(key)
        @relative_path =
          if schema.equal?(parent.schema)
            parent.relative_path.child(key)
          else
            JSONPointer.new_root(key)
          end
      end
    end

    def call(instance, key, schema = nil, subclass: self.class)
      child = subclass.new(schema || @schema, instance, parent: self, key: key)

      yield child

      @children[[key, instance.path]] = child unless child.discard?
    end

    def schema_node
      relative_path.eval(schema)
    end

    def sibling(instance, key)
      @parent.children[[key, instance.path]] if @parent
    end

    def annotate(value)
      @annotation = value
    end

    def failure(error = nil)
      @valid = false
      @error = error
    end

    def success
      @valid = true
      @error = nil
    end

    def skip_assertion
      @skip_assertion = true
    end

    def discard
      @discard = true
    end

    def discard?
      @discard
    end

    def valid?
      @valid
    end

    def passed?
      @valid || @skip_assertion
    end

    def absolute_uri
      return @ref_schema.canonical_uri if @ref_schema
      return nil if schema.canonical_uri.nil?

      path = JSONPointer.new(schema.canonical_uri.fragment || "") << relative_path
      schema.canonical_uri.dup.tap { |u| u.fragment = path.to_s }
    end

    def collect_annotations(instance = nil, key = nil)
      return if !valid? || discard?

      if @annotation &&
          (key.nil? || key == @key) &&
          (instance.nil? || instance.path == @instance.path)
        yield @annotation
      end

      @children.each do |_, child|
        child.collect_annotations(instance, key) do |annotation|
          yield annotation
        end
      end
    end

    def collect_errors(instance: nil, key: nil)
      return if valid? || discard?

      if @error &&
          (key.nil? || key == @key) &&
          (instance.nil? || instance.path == @instance.path)
        yield @error
      end

      @children.each do |_, child|
        child.collect_errors(instance, key) do |error|
          yield error
        end
      end
    end

    def output(format, **options)
      Formatters[format].call(self, **options)
    end
  end
end
