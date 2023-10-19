# frozen_string_literal: true

module JSONSkooma
  class Result
    attr_writer :ref_schema

    attr_reader :schema, :instance, :parent, :annotation, :error, :key

    def initialize(schema, instance, parent: nil, key: nil)
      reset_with(instance, key, parent, schema)
    end

    def children
      @children ||= {}
    end

    def each_children
      children.each_value do |child|
        child.each_value do |grandchild|
          yield grandchild
        end
      end
    end

    def path
      @path ||= @parent.nil? ? JSONPointer.new([]) : parent.path.child(key)
    end

    def relative_path
      @relative_path ||=
        if @parent.nil?
          JSONPointer.new([])
        elsif schema.equal?(parent.schema)
          parent.relative_path.child(key)
        else
          JSONPointer.new_root(key)
        end
    end

    def root
      @root ||= parent&.root || self
    end

    def reset_with(instance, key, parent, schema = nil)
      @schema = schema if schema
      @parent = parent
      @key = key
      @valid = true
      @instance = instance

      @children = nil
      @annotation = nil
      @discard = false
      @skip_assertion = false
      @error = nil
      @path = nil
      @ref_schema = nil
      @relative_path = nil
    end

    def call(instance, key, schema = nil)
      child = dup
      child.reset_with(instance, key, self, schema)

      yield child

      return if child.discard?
      (children[instance.path] ||= {})[key] = child
    end

    def schema_node
      relative_path.eval(schema)
    end

    def sibling(instance, key)
      @parent&.children&.dig(instance.path, key)
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

      children[instance.path]&.each_value do |child|
        child.collect_annotations(instance, key) do |annotation|
          yield annotation
        end
      end
    end

    def output(format, **options)
      Formatters[format].call(self, **options)
    end

    def to_s
      output(:simple)
    end
  end
end
