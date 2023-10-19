# frozen_string_literal: true

module JSONSkooma
  class JSONSchema < JSONNode
    attr_reader :uri, :cache_id, :registry
    attr_writer :metaschema_uri

    def initialize(value, registry: Registry::DEFAULT_NAME, cache_id: "default", uri: nil, metaschema_uri: nil, parent: nil, key: nil)
      super(value, parent: parent, key: key)

      @keywords = {}

      @cache_id = cache_id
      @registry = Registry[registry]
      self.metaschema_uri = metaschema_uri.is_a?(String) ? URI.parse(metaschema_uri) : metaschema_uri
      self.uri = uri.is_a?(String) ? URI.parse(uri) : uri

      return if type != "object"

      self.uri ||= URI("urn:uuid:#{SecureRandom.uuid}") if parent.nil?
      resolve_keywords(value.transform_keys(&:to_s))
      resolve_references if parent.nil?
    end

    def evaluate(instance, result = nil, ref: nil)
      return resolve_ref(ref).evaluate(instance, result) if ref

      instance = JSONSkooma::JSONNode.new(instance) unless instance.is_a?(JSONNode)

      result ||= Result.new(self, instance)
      case value
      when true
        # do nothing
      when false
        result.failure("The instance is disallowed by a boolean false schema")
      else
        @keywords.each do |key, keyword|
          next if keyword.static || !keyword.instance_types.include?(instance.type)

          result.call(instance, key, self) do |subresult|
            keyword.evaluate(instance, subresult)
          end
        end

        if result.children[instance.path]&.any? { |_, child| !child.passed? }
          result.failure
        end
      end

      result
    end

    def resolve_uri(uri)
      uri = URI.parse(uri)
      return uri if uri.absolute?
      return base_uri + uri if base_uri

      raise Error, "No base URI against which to resolve uri `#{uri}`"
    end

    def resolve_ref(uri)
      registry.schema(resolve_uri(uri), metaschema_uri: metaschema_uri, cache_id: cache_id)
    end

    def validate
      metaschema.evaluate(self)
    end

    def parent_schema
      return @parent_schema if instance_variable_defined?(:@parent_schema)

      node = parent
      while node
        return @parent_schema = node if node.is_a?(JSONSchema)

        node = node.parent
      end
    end

    def uri=(uri)
      return if @uri == uri

      @base_uri = nil
      @registry.delete_schema(@uri, cache_id: @cache_id) if @uri
      @uri = uri
      @registry.add_schema(@uri, self, cache_id: @cache_id) if @uri
    end

    def metaschema
      raise RegistryError, "The schema's metaschema URI has not been set" if metaschema_uri.nil?

      @metaschema ||= @registry.metaschema(metaschema_uri)
    end

    def metaschema_uri
      @metaschema_uri ||= parent_schema&.metaschema_uri
    end

    def base_uri
      return parent_schema&.base_uri unless uri

      @base_uri ||= uri.dup.tap { |u| u.fragment = nil }
    end

    def canonical_uri
      return uri if uri
      return @canonical_uri if instance_variable_defined?(:@canonical_uri)

      keys = []
      node = self
      while node.parent
        keys.unshift(node.key)
        node = node.parent

        if node.is_a?(JSONSchema) && node.uri
          fragment = JSONPointer.new(node.uri.fragment || "") << keys
          return @canonical_uri = node.uri.dup.tap { |u| u.fragment = fragment.to_s }
        end
      end
    end

    def resolve_references
      @keywords.each_value(&:resolve)
    end

    private

    def resolve_keywords(value)
      bootstrap(value)

      kw_classes = value.keys
        .reject { |k| @keywords.key?(k) }
        .map { |k| [k, kw_class(k)] }
        .to_h

      dependencies_in_order(kw_classes) do |kw_class|
        add_keyword(kw_class.new(self, value[kw_class.key]))
      end
    end

    def bootstrap(value)
      bootstrap_kw_classes = {
        "$schema" => Keywords::Core::Schema,
        "$id" => Keywords::Core::Id
      }

      bootstrap_kw_classes.each do |key, kw_class|
        next unless value.key?(key)

        add_keyword(kw_class.new(self, value[key]))
      end
    end

    def kw_class(k)
      metaschema.kw_class(k)
    end

    def add_keyword(kw)
      @keywords[kw.key] = kw
      __getobj__[kw.key] = kw.json
    end

    def dependencies_in_order(kw_classes)
      dependencies = kw_classes.each_value.with_object({}) do |kw_class, res|
        res[kw_class] = kw_class.depends_on.filter_map { |dep| kw_classes[dep] }
      end

      while dependencies.any?
        kw_class, _ = dependencies.find { |_, depclasses| depclasses.empty? }
        dependencies.delete(kw_class)
        dependencies.each_value { |deps| deps.delete(kw_class) }
        yield kw_class
      end
    end

    def parse_value(value)
      case value
      when true, false
        ["boolean", value]
      when Hash
        ["object", {}]
      else
        raise TypeError, "#{value} is not JSONSchema-compatible"
      end
    end
  end
end
